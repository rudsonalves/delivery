import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../common/utils/data_result.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository._();

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<DataResult<UserCredential>> create({
    required String email,
    required String password,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return DataResult.success(user);
    } catch (err) {
      log(err.toString());
      return DataResult.failure(FirebaseFailure(err.toString()));
    }
  }

  static Future<DataResult<UserCredential>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return DataResult.success(user);
    } catch (err) {
      log(err.toString());
      return DataResult.failure(FirebaseFailure(err.toString()));
    }
  }

  static Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (err) {
      log(err.toString());
      throw FirebaseFailure(err.toString());
    }
  }

  // Check user authentication status
  static bool isUserLoggedIn() {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  // Get current authenticated user
  static User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  // Observing changes in authentication state
  static Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  // Listen for autentication state changes
  static StreamSubscription<User?> userChanges({
    required void Function() notLogged,
    required void Function() logged,
    Function(dynamic error)? onError,
  }) {
    return FirebaseAuth.instance.userChanges().listen(
      (User? user) {
        if (user == null) {
          notLogged();
          log('User is currently signed out!');
        } else {
          logged();
          log('User is signed in!');
        }
      },
      onError:
          onError ?? (error) => log('Erro no stream de autenticação: $error'),
    );
  }
}
