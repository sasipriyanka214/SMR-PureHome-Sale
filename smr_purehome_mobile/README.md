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

Run Flask on the computer using `python app.py`. The app listens on all network
interfaces at port 5000. On first launch, enter the computer's LAN address,
for example `http://192.168.1.20:5000`. Find that address with `ipconfig` on
Windows. The phone and computer must be on the same Wi-Fi, and Windows Firewall
must allow Python to receive connections on the private network.

For the Android emulator, use `http://10.0.2.2:5000`. The app saves the address
on the device and provides settings to change it.

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
