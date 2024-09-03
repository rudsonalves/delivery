import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../firestore/user_firestore_repository.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository._();

  static const collectionAppSettings = 'appSettings';
  static const docAdminConfig = 'adminConfig';
  static const keyAdminId = 'adminId';

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<DataResult<UserModel>> create(UserModel user) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      if (userCredential.user == null) {
        throw Exception('unknown FirebaseAuth error');
      }

      final currentUser = await updateProfile(
        currentUser: userCredential.user!,
        displayName: user.name,
      );

      // await sendSignInLinkToEmail(currentUser!);

      // await signOut();

      if (currentUser == null) {
        throw Exception('unknown FirebaseAuth error');
      }

      // Set user uid
      user.id = currentUser.uid;

      // Check in AppSettings before querying Firestore
      final isFirstUser = await _checkAndSetFirstAdmin(user.id!);

      // Update the user model with the appropriate role
      user.role = isFirstUser ? UserRole.admin : user.role;

      // Save user in Farestore
      final result = await UserFirestoreRepository.set(user);
      if (result.isFailure) {
        throw Exception(result.error);
      }

      return DataResult.success(user);
    } catch (err) {
      final message = 'FirebaseAuthRepository.create error: $err';
      log(message);
      return DataResult.failure(FireAuthFailure(message));
    }
  }

  static Future<bool> _checkAndSetFirstAdmin(String userId) async {
    final app = locator<AppSettings>();
    if (app.adminChecked) {
      // It has been verified before, so it is not the first user
      return false;
    }

    final adminConfigRef = FirebaseFirestore.instance
        .collection(collectionAppSettings)
        .doc(docAdminConfig);

    try {
      final docSnapshot = await adminConfigRef.get();

      if (docSnapshot.exists) return false;
      // First time: Set this user as admin
      await adminConfigRef.set({keyAdminId: userId});
      // Update the local status to indicate that the check was successful
      await app.checkAdminChecked();
      return true;
    } catch (err) {
      final message =
          'FirebaseAuthRepository._checkAndSetFirstAdmin error: $err';
      log(message);
      return false;
    }
  }

  // FIXME: For now I have disable account verification by email so that I don´t
  //        have to use Dynamic Link in farebase, as the will be discontinued in
  //        August 2025.
  static Future<void> sendSignInLinkToEmail(User user) async {
    final acs = ActionCodeSettings(
      url: 'https://rralves.dev.br/delivery/',
      androidPackageName: 'br.dev.rralves.delivery',
      handleCodeInApp: true,
      // iOSBundleId: 'com.example.ios',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12',
    );

    auth
        .sendSignInLinkToEmail(
          email: user.email!,
          actionCodeSettings: acs,
        )
        .catchError(
            (onError) => log('Error sending email verification $onError'))
        .then((onValue) => log('Successfully sent email verification'));
  }

  static Future<User?> updateProfile({
    required User currentUser,
    String? displayName,
    String? photoURL,
    String? newPassword,
    PhoneAuthCredential? phoneCredential,
  }) async {
    try {
      await currentUser.updateDisplayName(displayName);
      await currentUser.updatePhotoURL(photoURL);
      if (phoneCredential != null) {
        await currentUser.updatePhoneNumber(phoneCredential);
      }
      if (newPassword != null) {
        await currentUser.updatePassword(newPassword);
      }
      await currentUser.reload();
      return auth.currentUser!;
    } catch (err) {
      final message = 'Update profile error: $err';
      log(message);
      return null;
    }
  }

  static Future<DataResult<User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw Exception('unknown FirebaseAuth error');
      }

      return DataResult.success(userCredential.user!);
    } catch (err) {
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      return DataResult.failure(FireAuthFailure(message));
    }
  }

  static Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (err) {
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      throw FireAuthFailure(message);
    }
  }

  // Check user authentication status
  static bool isUserLoggedIn() {
    final currentUser = auth.currentUser;
    return currentUser != null;
  }

  // Get current authenticated user
  static User? getCurrentUser() {
    return auth.currentUser;
  }

  // Observing changes in authentication state
  static Stream<User?> authStateChanges() {
    return auth.authStateChanges();
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
