# entregas

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Changelog

## 2024/09/02 - version: 0.0.1+3

Enhancements and improvements to user authentication, state management, and UI components

This commit introduces several enhancements and improvements across various files to improve user authentication, state management, and UI components. Key changes include:

1. android/app/src/main/AndroidManifest.xml
   - Commented out an intent filter for deep linking to `example.com` to prevent unintended navigation behavior.

2. assets/images/delivery_01.jpg
   - Added a new image asset `delivery_01.jpg` for use in the drawer header.

3. lib/common/models/user.dart
   - Created a new `UserModel` class to represent user data, including name, email, phone, and password.

4. lib/common/settings/app_settings.dart
   - Removed singleton pattern for `AppSettings` in favor of dependency injection.

5. lib/components/widgets/message_snack_bar.dart
   - Added a utility widget `showMessageSnackBar` to display messages using a `SnackBar`.

6. lib/components/widgets/password_text_field.dart
   - Added `focusNode` and `nextFocus` properties to improve form navigation and accessibility.

7. lib/components/widgets/state_loading.dart
   - Introduced `StateLoading` widget to display a loading indicator overlay.

8. lib/features/home/home_controller.dart
   - Integrated `UserStore` for managing user authentication state.
   - Added a `logout` method to handle user sign-out functionality.

9. lib/features/home/home_page.dart
   - Updated to use `AppSettings` through dependency injection.
   - Added a navigation drawer with logout functionality and a new image header.

10. lib/features/sign_in/sign_in_controller.dart
    - Created `SignInController` to manage user sign-in logic and state.

11. lib/features/sign_in/sign_in_page.dart
    - Refactored to utilize `SignInController` for managing form input and sign-in logic.
    - Enhanced user experience with error handling and form validation.

12. lib/features/sign_up/sign_up_controller.dart
    - Added `SignUpController` to manage user registration process and state.

13. lib/features/sign_up/sign_up_page.dart
    - Refactored to use `SignUpController` and improved form validation and error handling.

14. lib/locator.dart
    - Introduced a service locator using `GetIt` for dependency injection across the application.

15. lib/main.dart
    - Set up dependency injection by calling `setupDependencies()` during app initialization.

16. lib/my_material_app.dart
    - Updated to utilize `AppSettings` via dependency injection through the service locator.

17. lib/repository/firebase/firebase_auth_repository.dart
    - Enhanced Firebase authentication repository with additional error handling and profile update methods.

18. lib/stores/mobx/generic_functions.dart
    - Added utility functions for common form validation tasks.

19. lib/stores/mobx/sign_in_store.dart
    - Created `SignInStore` to manage state and validation for the sign-in form.

20. lib/stores/mobx/sign_up_store.dart
    - Enhanced `SignUpStore` with additional validation methods and state management.

21. lib/stores/user/user_store.dart
    - Refactored `UserStore` to include detailed user state management and profile handling.

22. pubspec.lock
    - Updated to include new dependencies: `firebase_dynamic_links` and `get_it`.

23. pubspec.yaml
    - Updated app version to `0.0.1+3`.
    - Added new dependencies for dynamic links and dependency injection.

These changes improve the overall user experience by enhancing the authentication process, simplifying state management, and providing a more robust and user-friendly interface.


## 2024/09/02 - version: 0.0.1+2

Initial commit for setting up Firebase integration and project structure

This commit introduces Firebase integration and sets up the basic project structure for the delivery control app. The following changes have been made:

1. .firebaserc
   - Created a new `.firebaserc` file to define the Firebase project configuration.

2. Makefile
   - Added a `Makefile` for common build and development tasks, such as cleaning the project, generating diffs, and pushing commits.

3. android/app/build.gradle
   - Updated `build.gradle` to include dependencies for Firebase Authentication and Google Play services.

4. android/settings.gradle
   - Updated the Kotlin plugin version to `2.0.20`.

5. firebase.json
   - Modified `firebase.json` to include emulator configuration and updated platform settings for Firebase.

6. lib/common/theme/app_text_style.dart
   - Created a new `AppTextStyle` class to define common text styles.

7. lib/common/utils/data_result.dart
   - Added a new `FirebaseFailure` class to handle Firebase-specific errors.

8. lib/components/widgets/big_bottom.dart
   - Created a `BigButton` widget to provide a customizable button component.

9. lib/components/widgets/custom_text_field.dart
   - Added a `fullBorder` parameter to control the appearance of text field borders.

10. lib/components/widgets/password_text_field.dart
    - Introduced a `PasswordTextField` widget with customizable parameters for enhanced user input security.

11. lib/features/home/home_controller.dart
    - Implemented `HomeController` to manage user authentication states and subscription handling.

12. lib/features/home/home_page.dart
    - Updated `HomePage` to integrate `HomeController` for managing authentication states.

13. lib/features/sign_in/sign_in_page.dart
    - Added `SignInPage` to handle user login functionality.

14. lib/features/sign_up/sign_up_page.dart
    - Added `SignUpPage` to facilitate user registration with form validation.

15. lib/main.dart
    - Refactored the main entry point to use `FirebaseService` for initializing Firebase.

16. lib/my_material_app.dart
    - Updated the app's routing configuration to include `SignInPage` and `SignUpPage`.

17. lib/repository/firebase/firebase_auth_repository.dart
    - Created `FirebaseAuthRepository` for managing Firebase authentication operations.

18. lib/services/firebase_service.dart
    - Introduced `FirebaseService` for handling Firebase initialization and logging.

19. lib/stores/auth/sign_up_store.dart
    - Set up MobX store `SignUpStore` to manage the state and validation of user input during sign-up.

20. lib/stores/user/user_store.dart
    - Created `UserStore` to manage user authentication states and operations using MobX.

21. lib/stores/user/user_store.g.dart
    - Generated MobX store code for `UserStore`.

22. pubspec.yaml
    - Bumped version to `0.0.1+2` to reflect the updated project configuration.

This commit establishes the foundation for the delivery control app with Firebase integration, user authentication, and structured codebase for further development.

