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

