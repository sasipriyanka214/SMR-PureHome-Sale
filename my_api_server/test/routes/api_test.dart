import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/api/login.dart' as login_route;
import '../../routes/api/status.dart' as status_route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /api/status', () {
    test('returns the API status and version', () async {
      final response = status_route.onGet(_MockRequestContext());

      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.json(),
        equals({
          'status': 'success',
          'message': 'SMR PureHome API is running successfully with Supabase!',
          'version': 'V18',
        }),
      );
    });
  });

  group('POST /api/login', () {
    test('requires an email and password', () async {
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(
        Request.post(
          Uri.parse('http://localhost/api/login'),
          headers: {'content-type': 'application/json'},
          body: jsonEncode({'email': 'user@example.com'}),
        ),
      );

      final response = await login_route.onPost(context);

      expect(response.statusCode, HttpStatus.badRequest);
      expect(
        await response.json(),
        equals({
          'status': 'error',
          'message': 'Email and password are required',
        }),
      );
    });

    test('rejects malformed JSON', () async {
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(
        Request.post(
          Uri.parse('http://localhost/api/login'),
          headers: {'content-type': 'application/json'},
          body: '{',
        ),
      );

      final response = await login_route.onPost(context);

      expect(response.statusCode, HttpStatus.badRequest);
      expect(
        await response.json(),
        equals({
          'status': 'error',
          'message': 'Invalid JSON request body',
        }),
      );
    });

    test(
      'returns the login template response for provided credentials',
      () async {
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(
          Request.post(
            Uri.parse('http://localhost/api/login'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              'email': 'user@example.com',
              'password': 'secret',
            }),
          ),
        );

        final response = await login_route.onPost(context);

        expect(response.statusCode, HttpStatus.ok);
        expect(
          await response.json(),
          equals({
            'status': 'success',
            'message': 'API Login endpoint template ready',
          }),
        );
      },
    );
  });
}
