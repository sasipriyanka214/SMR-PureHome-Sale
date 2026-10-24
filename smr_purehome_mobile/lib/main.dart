import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmrPureHomeApp());
}

class SmrPureHomeApp extends StatelessWidget {
  const SmrPureHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMR PureHome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const WebsiteScreen(),
    );
  }
}

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  static const _savedUrlKey = 'website_url';
  static const _emulatorUrl = 'http://10.0.2.2:5000';

  late final WebViewController _webViewController;
  final _urlController = TextEditingController();
  String? _websiteUrl;
  String? _loadError;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _loadError = null;
                _progress = 0;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _progress = 100);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() {
                _loadError =
                    'Could not open the website. Check the server address, '
                    'Wi-Fi connection, and that Flask is running.';
              });
            }
          },
        ),
      );
    _loadSavedUrl();
  }

  Future<void> _loadSavedUrl() async {
    final preferences = await SharedPreferences.getInstance();
    final savedUrl = preferences.getString(_savedUrlKey);
    if (!mounted) return;
    if (savedUrl == null) {
      setState(() => _websiteUrl = '');
      return;
    }
    _openWebsite(savedUrl);
  }

  Future<void> _openWebsite(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      setState(() {
        _websiteUrl = '';
        _loadError = 'Enter a valid address starting with http:// or https://';
      });
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_savedUrlKey, uri.toString());
    if (!mounted) return;
    setState(() {
      _websiteUrl = uri.toString();
      _loadError = null;
    });
    await _webViewController.loadRequest(uri);
  }

  Future<void> _showServerAddressDialog() async {
    _urlController.text = _websiteUrl?.isNotEmpty == true
        ? _websiteUrl!
        : _emulatorUrl;
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Website address'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: _urlController,
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Server URL',
              hintText: 'http://192.168.1.20:5000',
              helperText: 'Use your computer’s IP address on a real phone.',
            ),
            validator: (value) {
              final uri = Uri.tryParse(value?.trim() ?? '');
              if (uri == null ||
                  !uri.hasAuthority ||
                  (uri.scheme != 'http' && uri.scheme != 'https')) {
                return 'Enter a full http:// or https:// address';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final url = _urlController.text.trim();
              Navigator.pop(dialogContext);
              _openWebsite(url);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Future<void> _goBack() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = _websiteUrl?.isNotEmpty == true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMR PureHome'),
        actions: [
          IconButton(
            tooltip: 'Change website address',
            onPressed: _showServerAddressDialog,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_progress < 100 && hasUrl)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(
            child: !hasUrl
                ? _ConnectionPrompt(onConfigure: _showServerAddressDialog)
                : _loadError != null
                ? _ConnectionError(
                    message: _loadError!,
                    onRetry: () => _openWebsite(_websiteUrl!),
                    onConfigure: _showServerAddressDialog,
                  )
                : WebViewWidget(controller: _webViewController),
          ),
        ],
      ),
      floatingActionButton: hasUrl
          ? FloatingActionButton.small(
              tooltip: 'Go back',
              onPressed: _goBack,
              child: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }
}

class _ConnectionPrompt extends StatelessWidget {
  const _ConnectionPrompt({required this.onConfigure});

  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Connect to your SMR PureHome website',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter the website address. For a physical phone, use your '
              'computer’s local network IP address.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onConfigure,
              child: const Text('Set website address'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionError extends StatelessWidget {
  const _ConnectionError({
    required this.message,
    required this.onRetry,
    required this.onConfigure,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(onPressed: onRetry, child: const Text('Retry')),
                OutlinedButton(
                  onPressed: onConfigure,
                  child: const Text('Address settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
