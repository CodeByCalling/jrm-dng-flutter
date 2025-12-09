// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  // --- YOUR REAL KEYS ---
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9r4iFn5kVGpzFNDgoGwY-W6Z4PvjIi5A',
    appId: '1:219102672112:web:5148f724b7e601e62b3e35',
    messagingSenderId: '219102672112',
    projectId: 'jrm-member-dng-portal',
    authDomain: 'jrm-member-dng-portal.firebaseapp.com',
    storageBucket: 'jrm-member-dng-portal.firebasestorage.app',
    measurementId: 'G-4CV5EW4YKY',
  );

  // We reuse Web keys for Android/iOS/MacOS to prevent crashes during dev
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9r4iFn5kVGpzFNDgoGwY-W6Z4PvjIi5A',
    appId: '1:219102672112:web:5148f724b7e601e62b3e35',
    messagingSenderId: '219102672112',
    projectId: 'jrm-member-dng-portal',
    storageBucket: 'jrm-member-dng-portal.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9r4iFn5kVGpzFNDgoGwY-W6Z4PvjIi5A',
    appId: '1:219102672112:web:5148f724b7e601e62b3e35',
    messagingSenderId: '219102672112',
    projectId: 'jrm-member-dng-portal',
    storageBucket: 'jrm-member-dng-portal.firebasestorage.app',
    iosBundleId: 'com.jrm.jrmDngFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9r4iFn5kVGpzFNDgoGwY-W6Z4PvjIi5A',
    appId: '1:219102672112:web:5148f724b7e601e62b3e35',
    messagingSenderId: '219102672112',
    projectId: 'jrm-member-dng-portal',
    storageBucket: 'jrm-member-dng-portal.firebasestorage.app',
    iosBundleId: 'com.jrm.jrmDngFlutter',
  );
}