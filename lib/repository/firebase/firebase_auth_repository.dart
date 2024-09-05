import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';
import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../services/local_storage_service.dart';
import '../firestore/user_firestore_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository();

  static const collectionAppSettings = 'appSettings';
  static const docAdminConfig = 'adminConfig';
  static const keyAdminId = 'adminId';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final localService = locator<LocalStorageService>();
  final userFirestore = UserFirestoreRepository();

  String _phoneVerificationId = '';

  // User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Future<DataResult<UserModel>> create(UserModel user) async {
    try {
      // Create user in firebase
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      if (userCredential.user == null) {
        throw Exception('unknown FirebaseAuth error');
      }

      // Update user name (displayName)
      final currentUser = await _updateProfile(
        currentUser: userCredential.user!,
        displayName: user.name,
      );

      if (currentUser == null) {
        throw Exception('unknown FirebaseAuth error in updateProfile');
      }

      // Set user attributes
      user.id = currentUser.uid;
      user.creationAt = currentUser.metadata.creationTime;
      user.lastSignIn = currentUser.metadata.lastSignInTime;

      // Check in AppSettings before querying Firestore
      final isFirstUser = await _checkAndSetFirstAdmin(user.id!);

      // Update the user model with the appropriate role
      user.role = isFirstUser ? UserRole.admin : user.role;

      // Save user in Farestore using set, to insert user with same uid from
      // FirebaseAuth
      final result = await userFirestore.set(user);
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

  Future<bool> _checkAndSetFirstAdmin(String userId) async {
    final app = locator<AppSettings>();
    if (app.adminChecked) {
      // It has been verified before, so it is not the first user
      return false;
    }

    // Check by first registred user
    try {
      final adminConfigRef = FirebaseFirestore.instance
          .collection(collectionAppSettings)
          .doc(docAdminConfig);

      final docSnapshot = await adminConfigRef.get();

      if (docSnapshot.exists) return false;
      // First time: Set this user as admin
      await adminConfigRef.set({keyAdminId: userId});
      // Update the local store status to indicate that the check was successful
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
  @override
  Future<void> sendSignInLinkToEmail(String email) async {
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
          email: email,
          actionCodeSettings: acs,
        )
        .catchError(
            (onError) => log('Error sending email verification $onError'))
        .then((onValue) => log('Successfully sent email verification'));
  }

  // Update firebase profile with displayname, photoURL, PhoneAuthCredendial
  Future<User?> _updateProfile({
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

  @override
  Future<DataResult<UserModel>> signIn({
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

      final userAux = _getUserFrom(userCredential.user!);
      final user = await _recoverUserModel(userAux);
      log(user.toString());

      return DataResult.success(user);
    } catch (err) {
      await signOut();
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      return DataResult.failure(FireAuthFailure(message));
    }
  }

  Future<UserModel> _recoverUserModel(UserModel user) async {
    // Recover user from local server
    UserModel user1 = user.copyWith();

    // recover from local store
    UserModel? localUser = localService.getCachedUser();
    if (localUser != null) {
      if (localUser.id == user1.id) {
        user1.role = localUser.role;
        user1.userStatus = localUser.userStatus;
        return user1;
      }
      // New user conect in local device
      await localService.clearCachedUser();
    }

    // Recover user from firebase
    final result = await userFirestore.get(user1);
    if (result.isFailure) {
      throw Exception('get user in firebase error');
    }
    if (result.data == null) {
      throw Exception('user data not found!');
    }
    final user2 = result.data as UserModel;

    // Save in local store
    localService.setCachedUser(user2);
    return user2;
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (err) {
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      throw FireAuthFailure(message);
    }
  }

  // Check user authentication status
  @override
  bool isUserLoggedIn() {
    final currentUser = auth.currentUser;
    return currentUser != null;
  }

  // Get current authenticated user
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        await localService.clearCachedUser();
        return null;
      }

      final newUser = _getUserFrom(user);
      return await _recoverUserModel(newUser);
    } catch (err) {
      log('getCurrentUser: $err');
      return null;
    }
  }

  UserModel _getUserFrom(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
      phone: user.phoneNumber,
      emailVerified: user.emailVerified,
      photoURL: user.photoURL,
      creationAt: user.metadata.creationTime,
      lastSignIn: user.metadata.lastSignInTime,
    );
  }

  @override
  Future<void> requestPhoneNumberVerification(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      verificationCompleted: (PhoneAuthCredential credential) async {
        log('Verificatin completed');
        await auth.currentUser!.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException err) {
        log('Verificatin failed: $err');
      },
      codeSent: (String verificationId, int? resendToken) {
        log('Verification code send. Verification ID: $verificationId');
        _phoneVerificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Timeout for automatic verification');
      },
    );
  }

  @override
  Future<DataResult<void>> updatePhoneInAuth(String smsCode) async {
    User? user = auth.currentUser;

    if (user != null) {
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _phoneVerificationId,
          smsCode: smsCode,
        );
        await user.updatePhoneNumber(credential);
        log('Phone number updated successfully!');
        return DataResult.success(null);
      } catch (err) {
        final message = 'FirebaseAuthRepository.updatePhoneInAuth: $err';
        log(message);
        return DataResult.failure(FireAuthFailure(message));
      }
    }

    const message =
        'FirebaseAuthRepository.updatePhoneInAuth: user is not logged!';
    log(message);
    return DataResult.failure(const FireAuthFailure(message));
  }

  // Observing changes in authentication state
  // Stream<User?> authStateChanges() {
  //   return auth.authStateChanges();
  // }

  // Listen for autentication state changes
  // @override
  // StreamSubscription<UserModel?> userChanges({
  //   required void Function() notLogged,
  //   required void Function(UserModel) logged,
  //   Function(dynamic error)? onError,
  // }) {
  //   return FirebaseAuth.instance.userChanges().asyncMap((User? user) async {
  //     if (user == null) {
  //       notLogged();
  //       log('User is currently signed out!');
  //       return null;
  //     } else {
  //       final newUser = _getUserFrom(user);
  //       final userModel = await _recoverUserModel(newUser);
  //       logged(userModel);
  //       log('User is signed in!');
  //       return userModel;
  //     }
  //   }).listen(
  //     (UserModel? userModel) {},
  //     onError:
  //         onError ?? (error) => log('Erro no stream de autenticação: $error'),
  //   );
  // }
}
