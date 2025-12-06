
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopment',
    appId: '1:123456789:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789',
    projectId: 'rumour-chat-app',
    authDomain: 'rumour-chat-app.firebaseapp.com',
    databaseURL: 'https://rumour-chat-app.firebaseio.com',
    storageBucket: 'rumour-chat-app.appspot.com',
  );
}
