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
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBVOgkeUTAEQWGASAr_Drutj1fZ5NV65Ik',
    appId: '1:304260295849:web:26e3166274c539d4d4cdb8',
    messagingSenderId: '304260295849',
    projectId: 'car-maintenance-app-fyp',
    authDomain: 'car-maintenance-app-fyp.firebaseapp.com',
    storageBucket: 'car-maintenance-app-fyp.appspot.com',
    measurementId: 'G-3VNT8J1P6B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCa_GD1F_Si-dxYe_6_sztVFPvNhlm3WkI',
    appId: '1:304260295849:android:4055e318f434b959d4cdb8',
    messagingSenderId: '304260295849',
    projectId: 'car-maintenance-app-fyp',
    storageBucket: 'car-maintenance-app-fyp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfRu44SapfB-JtNYeAmY5muv8Two5EZ0g',
    appId: '1:304260295849:ios:e7c3ba81dcc682d8d4cdb8',
    messagingSenderId: '304260295849',
    projectId: 'car-maintenance-app-fyp',
    storageBucket: 'car-maintenance-app-fyp.appspot.com',
    iosBundleId: 'com.example.carmaintenanceapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfRu44SapfB-JtNYeAmY5muv8Two5EZ0g',
    appId: '1:304260295849:ios:e7c3ba81dcc682d8d4cdb8',
    messagingSenderId: '304260295849',
    projectId: 'car-maintenance-app-fyp',
    storageBucket: 'car-maintenance-app-fyp.appspot.com',
    iosBundleId: 'com.example.carmaintenanceapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBVOgkeUTAEQWGASAr_Drutj1fZ5NV65Ik',
    appId: '1:304260295849:web:95339397f04455b7d4cdb8',
    messagingSenderId: '304260295849',
    projectId: 'car-maintenance-app-fyp',
    authDomain: 'car-maintenance-app-fyp.firebaseapp.com',
    storageBucket: 'car-maintenance-app-fyp.appspot.com',
    measurementId: 'G-YFL90CGL6S',
  );
}
