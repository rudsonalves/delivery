import 'dart:developer';

import 'package:delivery/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService._();

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('Firebase initialized successfully');
    } catch (err) {
      log('Error initializing Firebase: $err');
    }
  }

  // Logging Firebase-related errors
  static void logFirebaseError(String message) {
    log("Erro no Firebase: $message");
  }
}
