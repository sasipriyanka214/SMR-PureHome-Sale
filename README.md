# SMR PureHome Android app

This Flutter app opens the existing SMR PureHome website inside an Android
WebView. It is a website wrapper, not a native rewrite. The website handles its
own login and features.

## Generate the Android platform project

Install Flutter (including Android Studio and the Android SDK), then run these
commands from this folder:

```powershell
flutter create --platforms=android --project-name smr_purehome_mobile .
flutter pub get
```

In `android/app/src/main/AndroidManifest.xml`, add the Internet permission
above `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

For local development over HTTP, add
`android:usesCleartextTraffic="true"` to the `<application>` element. This is
needed for a local Flask URL; use HTTPS and remove this setting for a production
deployment.

Build the installable APK with:

```powershell
flutter build apk --release
```

The APK will be at
`build\app\outputs\flutter-apk\app-release.apk`. Transfer it to the Android
phone and open it to install. Android may ask you to allow installing apps from
the file manager or browser used to open the APK.

## Connect to the website

On first launch, the app opens the deployed SMR PureHome website:
`https://smr-purehome-sales-1.onrender.com`. The address is saved on the device
and can be changed from the settings icon.

For local development, start Flask with `python app.py` and set the address to
`http://10.0.2.2:5000` in an Android emulator, or
`http://<computer-LAN-IP>:5000` on a physical phone on the same Wi-Fi network.
Windows Firewall must allow Python to receive connections on the private
network.

Do not send real passwords over plain HTTP on an untrusted network. Deploy the
website behind HTTPS before using it outside local development.
cd "C:\Users\master\Downloads\SMR_PureHome_V18_Orders_AdminProducts_BeatLock_GST_UPDATED\smr_purehome_mobile"

flutter --version
flutter doctor

flutter create --platforms=android --project-name smr_purehome_mobile .
flutter pub get
flutter analyze
flutter test
flutter build apk --releasecd "C:\Users\master\Downloads\SMR_PureHome_V18_Orders_AdminProducts_BeatLock_GST_UPDATED\smr_purehome_mobile"

flutter --version
flutter doctor

flutter create --platforms=android --project-name smr_purehome_mobile .
flutter pub get
flutter analyze
flutter test
flutter build apk --release
