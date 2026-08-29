import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBivI9IW9KRhNwj2LI9wWuk6yJhc7BNVac',
    appId: '1:637129120968:web:00dc895a0f956b2a1f19fd',
    messagingSenderId: '637129120968',
    projectId: 'minhasaude-d53f6',
    authDomain: 'minhasaude-d53f6.firebaseapp.com',
    storageBucket: 'minhasaude-d53f6.firebasestorage.app',
    measurementId: 'G-E5F8RVZZFQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBivI9IW9KRhNwj2LI9wWuk6yJhc7BNVac',
    appId: '1:637129120968:web:00dc895a0f956b2a1f19fd',
    messagingSenderId: '637129120968',
    projectId: 'minhasaude-d53f6',
    storageBucket: 'minhasaude-d53f6.firebasestorage.app',
  );
}
