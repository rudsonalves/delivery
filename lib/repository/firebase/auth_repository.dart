import 'dart:async';

import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';

/// The abstract class `AuthRepository` defines methods for user authentication
/// in a system, including user creation, login, logout, and monitoring changes
/// in user authentication status.
abstract class AuthRepository {
  /// Creates a new user in the authentication system.
  ///
  /// This method takes a [UserModel] object that contains the user's information
  /// to be created. It returns a [DataResult] containing the created [UserModel]
  /// or an error if the creation fails.
  ///
  /// - [user]: A [UserModel] object containing the user's data.
  ///
  /// Returns a [DataResult<UserModel>] indicating the success or failure of the
  /// operation.
  Future<DataResult<UserModel>> create(UserModel user);

  /// Sends a sign-in link to the specified email address.
  ///
  /// This method is used to request email-based authentication by sending a
  /// sign-in link to the specified email address.
  ///
  /// - [email]: The email address to which the sign-in link will be sent.
  Future<void> sendSignInLinkToEmail(String email);

  /// Signs in a user to the system.
  ///
  /// This method authenticates a user using the provided email and password.
  /// It returns a [DataResult] containing the authenticated [UserModel] or an
  /// error if the login fails.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  ///
  /// Returns a [DataResult<UserModel>] indicating the success or failure of the
  /// login.
  Future<DataResult<UserModel>> signIn({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  ///
  /// This method logs out the user who is currently authenticated in the system.
  Future<void> signOut();

  /// Checks the authentication status of the current user.
  ///
  /// Returns `true` if a user is currently authenticated, otherwise `false`.
  bool isUserLoggedIn();

  /// Retrieves the currently authenticated user.
  ///
  /// This method returns the [UserModel] of the user currently authenticated
  /// in the system, or `null` if no user is authenticated.
  ///
  /// Returns a [Future<UserModel?>] representing the current authenticated user
  ///  or `null`.
  Future<UserModel?> getCurrentUser();

  /// Monitors changes in the authentication status of the user.
  ///
  /// This method returns a [StreamSubscription] that listens to changes in the
  /// user's authentication status. It invokes the [notLogged] callback when the
  /// user is logged out and the [logged] callback when the user is logged in.
  /// An optional [onError] callback can be provided to handle errors.
  ///
  /// - [notLogged]: A callback function invoked when the user is not logged in.
  /// - [logged]: A callback function invoked when the user is logged in.
  /// - [onError]: An optional callback function for handling errors.
  ///
  /// Returns a [StreamSubscription<UserModel?>] for managing the stream.
  // StreamSubscription<UserModel?> userChanges({
  //   required void Function() notLogged,
  //   required void Function(UserModel) logged,
  //   Function(dynamic error)? onError,
  // });

  Future<void> requestPhoneNumberVerification(String phoneNumber);

  Future<DataResult<void>> updatePhoneInAuth(String smsCode);
}
