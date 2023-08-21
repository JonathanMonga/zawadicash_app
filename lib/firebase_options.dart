// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0S79OIQDuw6FjOzyuiqi_jHFpI-7viPg',
    appId: '1:65843335919:android:4fee7f078b89bada3bc11a',
    messagingSenderId: '65843335919',
    projectId: 'zawadicash-wallet',
    storageBucket: 'zawadicash-wallet.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdeefk6opy5By7lEUwvx7XGXxE4eBYsSk',
    appId: '1:65843335919:ios:6cfd3e11754e1d263bc11a',
    messagingSenderId: '65843335919',
    projectId: 'zawadicash-wallet',
    storageBucket: 'zawadicash-wallet.appspot.com',
    iosClientId: '65843335919-d2r7c3gbkdmn1n9p0kqf1iad6m6ev5c7.apps.googleusercontent.com',
    iosBundleId: 'io.zawadicash',
  );
}
