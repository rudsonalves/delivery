import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';
import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../services/local_storage_service.dart';

// Errors codes:
// 200 - user needs to verify his email,
// 201 - unknown FirebaseAuth error,
// 202 - ApiError,
// 203 - user is not logged,
// 204 - credentials error,
// 205 - this system already has an admin user

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository();

  static const collectionAppSettings = 'appSettings';
  static const docAdminConfig = 'adminConfig';
  static const keyAdminId = 'adminId';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final localService = locator<LocalStorageService>();

  String _phoneVerificationId = '';

  User? firebaseUser;

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
      firebaseUser = await _updateProfile(
        currentUser: userCredential.user!,
        displayName: user.name,
      );

      if (firebaseUser == null) {
        throw Exception('unknown FirebaseAuth error in updateProfile');
      }

      // Set user attributes
      user.id = firebaseUser!.uid;
      user.creationAt = firebaseUser!.metadata.creationTime;
      user.lastSignIn = firebaseUser!.metadata.lastSignInTime;

      // Check in AppSettings before querying Firestore
      final isFirstUser = await _checkAndSetFirstAdmin(user.id!);

      // Update the user model with the appropriate role
      if (isFirstUser) {
        user.role = UserRole.admin;
      } else if (user.role == UserRole.admin) {
        throw Exception('this system already has an admin user');
      }

      // set claims
      await _setUserClaims(user);

      return DataResult.success(user);
    } catch (err) {
      final message = 'FirebaseAuthRepository.create error: $err';
      log(message);
      int? code;
      if (firebaseUser != null) {
        code = await _deleteFirebaseUser(firebaseUser);
      }
      return DataResult.failure(FireAuthFailure(
        message: message,
        code: code ?? 202,
      ));
    }
  }

  Future<int?> _deleteFirebaseUser(User? firebaseUser) async {
    if (firebaseUser != null) {
      await firebaseUser.delete();
      log('User remove becouse of error: ${firebaseUser.uid}');
      return 205;
    }
    return null;
  }

  Future<void> _setUserClaims(UserModel user) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Revalidar o token de autenticação do usuário
        await firebaseUser.getIdToken(true);

        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('setUserClaims');
        await callable.call(<String, dynamic>{
          'uid': user.id,
          'role': user.role.index,
          'status': user.userStatus.index,
          'managerId': user.bossId,
        });
      } else {
        throw Exception("User not authenticated");
      }
    } catch (err) {
      final message = 'Error setting user claims: $err';
      throw Exception(message);
    }
  }

  Future<bool> _checkAndSetFirstAdmin(String userId) async {
    final app = locator<AppSettings>();
    // It has been verified before, so it is not the first user
    if (locator<AppSettings>().adminChecked) {
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
        return DataResult.failure(
          const GenericFailure(
            message:
                'FirebaseAuthRepository.signIn error: unknown FirebaseAuth error',
            code: 201,
          ),
        );
      }

      UserModel user = await _getUserFrom(userCredential.user!);

      // Recuperar os custom claims
      final firebaseUser = userCredential.user!;
      user = await _getClaims(firebaseUser, user);

      if (user.role != UserRole.delivery && !user.emailVerified) {
        return DataResult.failure(
          const GenericFailure(
            message:
                'FirebaseAuthRepository.signIn error: user needs to verify his email',
            code: 200,
          ),
        );
      }

      return DataResult.success(user);
    } catch (err) {
      await signOut();
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      final code =
          (message.contains('[firebase_auth/wrong-password]')) ? 204 : 202;
      return DataResult.failure(FireAuthFailure(
        message: message,
        code: code,
      ));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (err) {
      final message = 'FirebaseAuthRepository.signIn error: $err';
      log(message);
      throw FireAuthFailure(message: message);
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
      final firebaseUser = auth.currentUser;
      if (firebaseUser == null) {
        await localService.clearCachedUser();
        return null;
      }

      final user = await _getUserFrom(firebaseUser);
      return await _getClaims(firebaseUser, user);
    } catch (err) {
      log('getCurrentUser: $err');
      return null;
    }
  }

  // Recover user claims
  Future<UserModel> _getClaims(User firebaseUser, UserModel user) async {
    final idTokenResult = await firebaseUser.getIdTokenResult(true);
    final claims = idTokenResult.claims!;
    return user.copyWith(
      role: UserRole.values[claims['role'] as int],
      userStatus: UserStatus.values[claims['status'] as int],
      bossId: claims['managerId'] as String?,
      // emailVerified: claims['email_verified'] as bool,
    );
  }

  Future<UserModel> _getUserFrom(User user) async {
    await user.reload();

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
    String formattedPhoneNumber =
        '+55${phoneNumber.replaceAll(RegExp(r'[^\d]'), '')}';
    await auth.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
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
        return DataResult.failure(FireAuthFailure(
          message: message,
          code: 202,
        ));
      }
    }

    const message =
        'FirebaseAuthRepository.updatePhoneInAuth: user is not logged!';
    log(message);
    return DataResult.failure(const FireAuthFailure(
      message: message,
      code: 203,
    ));
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      log('Password rest email sent to $email');
    } catch (err) {
      final message = 'UserFirestoreRepository.sendPasswordResetEmail: $err';
      log(message);
    }
  }
}
