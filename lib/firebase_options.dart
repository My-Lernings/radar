// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
///
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyDccweZwVZZrZYGfyFquh9tDiIiYKvl3Mc',
    appId: '1:625009145852:android:2aeb09880aee37ba522479',
    messagingSenderId: '625009145852',
    projectId: 'locale-346911',
    databaseURL: 'https://locale-346911-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'locale-346911.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf5unt4dajAvvZr61IUEoMBX_Z5Fp7jm4',
    appId: '1:625009145852:ios:9a16d83b62e5f385522479',
    messagingSenderId: '625009145852',
    projectId: 'locale-346911',
    databaseURL: 'https://locale-346911-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'locale-346911.appspot.com',
    iosClientId: '625009145852-pgvq92fuk5mus3tpmblhjoqbjucuca5m.apps.googleusercontent.com',
    iosBundleId: 'com.micacreativa.locale',
  );
}
