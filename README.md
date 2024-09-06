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

## 2024/09/06 - version: 0.1.5+9

Added new text styles and updated various UI components to enhance user experience.

1. lib/common/theme/app_text_style.dart
   - Added new text styles: `font12Bold`, `font14SemiBold`, `font15`, `font15Bold`, `font16`, `font16Bold`, and `font18`.
   - These styles provide more flexibility for different text sizes and weights across the application.

2. lib/components/widgets/message_snack_bar.dart
   - Refactored `showMessageSnackBar` to include an optional `title` parameter and updated the `message` parameter to accept a `Widget`.
   - Added `closeIcon` and `animation` for improved user interaction.
   - Modified `SnackBar` shape for better alignment and visual appearance.

3. lib/components/widgets/simple_message.dart *(New File)*
   - Created `SimpleMessage` widget for displaying simple messages with optional icons based on message type.
   - Added a `MessageType` enum to support different message types: `none`, `error`, and `warning`.
   - Provided a static `open` method for easily displaying the message in a dialog.

4. lib/features/sign_in/sign_in_controller.dart
   - Added `sendPasswordResetEmail` method for sending a password reset email.

5. lib/features/sign_in/sign_in_page.dart
   - Updated `_signIn` and `_recoverPassword` methods to display rich text messages with different styles based on conditions.
   - Added a button for users to recover their password via email, integrating with the new reset password functionality.
   - Created a `SnackBarTitle` widget to display titles in the `SnackBar`.

6. lib/features/sign_up/sign_up_page.dart
   - Enhanced the `signUp` method to display the message using the `Text` widget with custom styles.
   - Improved the error and success feedback to the user when signing up.

7. lib/repository/firebase/auth_repository.dart
   - Added the `sendPasswordResetEmail` method definition for password reset functionality.

8. lib/repository/firebase/firebase_auth_repository.dart
   - Implemented `sendPasswordResetEmail` method to send password reset emails using Firebase's `auth` API.

9. lib/stores/mobx/sign_in_store.dart
   - Added `isEmailValid` method to validate email format and ensure it's correct before performing actions.

This commit introduces several new text styles and UI improvements, along with the ability to send password reset emails. It enhances the feedback provided to users in various flows like sign-in and sign-up.


## 2024/09/06 - version: 0.1.4+8

Implement personal data handling and splash screen initialization

In this commit, several improvements and additions were made to the code. The AddressModel class now includes new fields such as type, latitude, longitude, and updatedAt, allowing better control over address types and geographical coordinates. The serialization and deserialization of the model were updated to handle these new attributes. Additionally, the string representation of the address was modified to include the address type.

A new ClientModel class was introduced to manage client data, which includes fields for name, email, phone, and an associated AddressModel. Serialization methods and helper functions were added for easy handling of client data.

Other significant changes include updates to the UserRole enum, which renamed client and consumer to business for better clarity. The HomeController and HomePage now check if the user has a phone number and redirects to the PersonDataPage if it's missing.

Additionally, the DeliveryPersonController was removed and replaced by the PersonController to handle personal data. The PersonDataPage was introduced to manage and update user personal information, such as phone numbers and addresses.

Finally, the commit adds a SplashPage and SplashController for handling the app's splash screen and initializing user data when the app launches. Several adjustments were made to controllers and routes to accommodate these new features.

1. lib/common/models/adreess.dart
   - Imported `dart:convert` to handle JSON serialization.
   - Added `type`, `latitude`, and `longitude` properties to `AddressModel`.
   - Updated the constructor to initialize `type` as 'Residencial', `latitude`, `longitude`, and `updatedAt` with default values.
   - Modified the `addressString` method to include the `type` in the string representation.
   - Added `updatedAt` to store the last update time.
   - Updated `copyWith` to handle the new properties (`type`, `latitude`, `longitude`, `updatedAt`).
   - Modified `toMap` and `fromMap` to serialize and deserialize the new properties.
   - Added `toJson` and `fromJson` methods for JSON conversion.
   - Overrode `==` and `hashCode` to include the new properties.

2. lib/common/models/client.dart
   - Created `ClientModel` to represent a client entity with fields such as `id`, `name`, `email`, `phone`, `address`, and timestamps (`createdAt`, `updatedAt`).
   - Added `copyWith` method to create a copy of the object with modified values.
   - Implemented `toMap` and `fromMap` methods for serialization and deserialization of the client model.
   - Added `toJson` and `fromJson` methods for JSON conversion.
   - Overrode `==` and `hashCode` for object comparison.
   - Implemented `toString` method for string representation of the client model.

3. lib/common/models/user.dart
   - Renamed the `client` role to `business` in the `UserRole` enum to better reflect the role’s purpose.

4. lib/components/widgets/custom_text_field.dart
   - Added the `textCapitalization` parameter to customize text capitalization behavior.

5. lib/features/home/home_controller.dart
   - Added `store` as a new property initialized to `HomeStore`.
   - Updated `init()` method to check if the user is logged in and set the `store.hasPhone` accordingly.

6. lib/features/home/home_page.dart
   - Updated the floating action button to navigate to `PersonDataPage` instead of the old delivery person page.
   - Added post-frame callback in `initState` to redirect to `PersonDataPage` if the user does not have a phone number registered.

7. lib/features/person_data/person_data_controller.dart
   - Created `PersonController` to manage personal data input, including phone verification.
   - Implemented `save()` method to request phone number verification and handle SMS code input through a custom dialog.

8. lib/features/person_data/person_data_page.dart
   - Renamed from `DeliveryPersonPage` to `PersonDataPage` to generalize the functionality for personal data input.
   - Updated the UI to reflect personal data input (phone, ZIP code, etc.) instead of delivery person data.

9. lib/features/person_data/widgets/text_input_dialog.dart
   - Created a new widget `TextInputDialog` to display a dialog for SMS code input, allowing for future extensions.

10. lib/features/sign_in/sign_in_controller.dart
    - Refactored the `init()` method to no longer initialize the user directly since this is handled elsewhere.
    - Added `userStatus` getter to expose the current user’s status.

11. lib/features/sign_in/sign_in_page.dart
    - Updated the navigation behavior to use `Navigator.pushReplacementNamed` for better user experience when transitioning between pages.

12. lib/features/sign_up/sign_up_page.dart
    - Removed the back button from the app bar for consistency during sign-up.

13. lib/features/splash/splash_controller.dart
    - Created `SplashController` to manage initialization logic for the splash screen, including checking if the user is logged in.

14. lib/features/splash/splash_page.dart
    - Created a new `SplashPage` to serve as the app’s initial screen, showing loading animations and handling navigation based on the user’s login state.

15. lib/my_material_app.dart
    - Set `SplashPage` as the initial route.
    - Updated the route for `PersonDataPage` to replace the old delivery person route.

16. lib/repository/firebase/firebase_auth_repository.dart
    - Refactored `requestPhoneNumberVerification` to format the phone number properly and handle verification via Firebase’s phone authentication.

17. lib/stores/mobx/home_store.dart
    - Created `HomeStore` to manage user-specific states such as `hasPhone` and `hasAddress`.

18. lib/stores/mobx/personal_data_store.dart
    - Renamed from `DeliveryPersonStore` to `PersonalDataStore` to reflect its broader role in managing personal data.

19. lib/stores/user/user_store.dart
    - Added a new observable property `userStatus` to track user authentication status changes.
    - Updated the `initializeUser`, `signUp`, and `logout` methods to toggle `userStatus` based on the user’s authentication state.


## 2024/09/05 - version: 0.1.3+7

Add Project Delivery Scrum Plan and Firebase Configuration

This commit introduces detailed planning for the Project Delivery using Scrum methodology and updates to the Firebase configuration and authentication flow.

1. `Projeto Delivery Scrum.md`
   - Added a comprehensive project planning document, including initial setup, user authentication, profile management, delivery request handling, geolocation, notifications, and admin control.

2. `database.rules.json`
   - Added default Firebase database security rules to disable read and write access by default for all users.

3. `firebase.json`
   - Configured Firebase emulators for authentication, Firestore, and storage.
   - Linked database rules and Firestore index settings to the project.

4. `firestore.indexes.json`
   - Created an empty Firestore index configuration for future usage.

5. `firestore.rules`
   - Added Firestore security rules, defining permissions for user documents and app settings.

6. `lib/common/models/user.dart`
   - Extended the `UserModel` class to include new fields: `emailVerified`, `photoURL`, `creationAt`, and `lastSignIn`.
   - Introduced a new method `ptUserRole` to map user roles to titles and icons.

7. `lib/common/theme/app_text_style.dart`
   - Added several new text styles for different font sizes and weights.

8. `lib/features/home/home_controller.dart`
   - Integrated current user data retrieval into the `HomeController`.

9. `lib/features/home/home_page.dart`
   - Refactored the theme toggle button for better readability and consistency.

10. `lib/features/home/widgets/custom_drawer_header.dart`
    - Created a new custom widget for the drawer header that displays user information and a dynamic background image.

11. `lib/features/home/widgets/home_drawer.dart`
    - Refactored to use `CustomDrawerHeader` for better modularization.

12. `lib/features/sign_in/sign_in_controller.dart`
    - Refactored the `signIn` method to align with new authentication flow.

13. `lib/features/sign_in/sign_in_page.dart`
    - Added a theme toggle button to the app bar for improved UI consistency.

14. `lib/features/sign_up/sign_up_controller.dart`
    - Removed phone number validation and integrated email verification upon signup.

15. `lib/features/sign_up/sign_up_page.dart`
    - Updated the signup flow to guide the user to confirm their email for account activation.

16. `lib/locator.dart`
    - Registered and disposed of user-related services.

17. `lib/repository/firebase/auth_repository.dart`
    - Refactored authentication repository to support email and phone verification.

18. `lib/repository/firebase/firebase_auth_repository.dart`
    - Enhanced authentication logic, including phone verification and email confirmation handling.

19. `lib/repository/firestore/user_firestore_repository.dart`
    - Refactored user repository to handle Firestore interactions with extended attributes.

20. `lib/repository/firestore/user_repository.dart`
    - Added a new abstract repository for user-related Firestore operations.

21. `lib/stores/mobx/sign_up_store.dart`
    - Removed phone validation logic from the sign-up store.

22. `lib/stores/user/user_store.dart`
    - Refactored user store to support email link verification and new user authentication flow.

23. `pubspec.lock`, `pubspec.yaml`
    - Adjusted dependencies to move `build_runner` to dev dependencies for optimization.

This commit structures the project with clear deliverables, improved user authentication logic, and enhanced modularization for future scalability.


## 2024/09/05 - version: 0.1.2+6

Refactor and Enhance User Authentication and Management

This commit refactors several parts of the codebase to enhance user authentication, user management, and general structure for better maintainability and functionality.

1. `lib/common/models/user.dart`
   - Fixed a typo in the `userStatus` map conversion from `map['UserStatus']` to `map['userStatus']` to align with camelCase naming conventions.

2. `lib/common/settings/app_settings.dart`
   - Updated the import path for `local_storage_service.dart` from `../storage/` to `../../services/` for consistency with the new directory structure.

3. `lib/components/widgets/message_snack_bar.dart`
   - Imported `app_text_style.dart` for consistent text styling.
   - Changed `message` parameter type from `Widget` to `String`.
   - Updated `time` default value from `3` to `5` seconds for longer visibility.
   - Adjusted `SnackBar` content to use a `Text` widget with styling from `AppTextStyle`.
   - Added `textColor` for `SnackBarAction` to enhance visual clarity.

4. `lib/components/widgets/password_text_field.dart`
   - Introduced a new optional callback `onFieldSubmitted`.
   - Adjusted constructor parameters for better flexibility and default values.
   - Enhanced `TextField` submission logic to unfocus and call `onFieldSubmitted` if provided.

5. `lib/features/home/home_controller.dart`
   - Removed unused imports and Firebase authentication logic for a cleaner, more focused controller.
   - Simplified `init` method by removing the subscription to user status changes.

6. `lib/features/home/widgets/home_drawer.dart`
   - Updated color handling to consider both light and dark themes, improving UI consistency.

7. `lib/features/sign_in/sign_in_controller.dart`
   - Added import for `data_result.dart`.
   - Refactored `signIn` method to return a `DataResult<UserModel>` for more explicit error handling and response management.

8. `lib/features/sign_in/sign_in_page.dart`
   - Added import for `mobx.dart`.
   - Introduced a `ReactionDisposer` to manage MobX reactions.
   - Updated `_signIn` method to handle responses with detailed error messages.

9. `lib/features/sign_up/sign_up_controller.dart`
   - Added a getter `isLoggedIn` to check if the user is logged in.

10. `lib/features/sign_up/sign_up_page.dart`
    - Added import for `mobx.dart`.
    - Introduced a `ReactionDisposer` to manage MobX reactions for user login state changes.
    - Improved feedback messages in the `_signUp` method for better user guidance.

11. `lib/locator.dart`
    - Updated import path for `local_storage_service.dart` to reflect the new directory structure.

12. `lib/repository/firebase/auth_repository.dart`
    - Created a new `AuthRepository` class for handling all authentication-related tasks.
    - Implemented various methods for user authentication, profile updates, and monitoring authentication state.

13. `lib/repository/firestore/user_firestore_repository.dart`
    - Standardized log messages for consistency and clarity.
    - Updated method names for better alignment with functionality.

14. `lib/services/local_storage_service.dart`
    - Renamed from `lib/common/storage/local_storage_service.dart` to `lib/services/local_storage_service.dart` to follow new directory organization.
    - Adjusted import paths accordingly.

15. `lib/stores/user/user_store.dart`
    - Refactored to use the new `AuthRepository` for authentication tasks.
    - Simplified user state management and initialization logic.
    - Improved login, sign-up, and logout methods for better error handling and response management.

16. `lib/stores/user/user_store.g.dart`
    - Updated generated code to reflect changes in the `UserStore` for MobX state management.

This commit enhances the overall structure and usability of the authentication system, providing a more streamlined and error-resilient approach to user management.


## 2024/09/03 - version: 0.1.0+5

Refactor: Implement local storage service and enhance user management

This commit introduces a refactor to the codebase, focusing on implementing a new local storage service and enhancing user management across the application. The key changes are as follows:

1. Refactoring App Settings
   - Replaced direct usage of `SharedPreferences` in `AppSettings` with a new `LocalStorageService` for more modular and testable code.
   - Updated methods to use the new local storage service (`setIsDark`, `setAdminChecked`).

2. New LocalStorageService Added
   - Created `lib/common/storage/local_storage_service.dart` to encapsulate all local storage operations, including:
     - Theme settings (`isDark`, `setIsDark`).
     - Admin check status (`adminChecked`, `setAdminChecked`).
     - User caching (`setCachedUser`, `getCachedUser`, `clearCachedUser`).

3. Updates to SignIn and SignUp Controllers
   - Refactored `SignInController` and `SignUpController` to use `pageStore` instead of `signUpStore` for improved readability and consistency.
   - Enhanced the controllers to utilize the newly introduced `LocalStorageService` for better state management.

4. Enhanced User Store with Local Caching
   - Modified `UserStore` to use `LocalStorageService` for caching the current user and maintaining user session state.
   - Added methods for retrieving the current user from local storage or Firestore if not found locally.

5. Firestore and Firebase Auth Repository Enhancements
   - Introduced constants for Firestore collection and document names to improve maintainability and reduce hardcoded strings.
   - Updated `FirebaseAuthRepository` to integrate with local storage checks for the first user admin setup.

6. UI and Page Logic Updates
   - Adjusted `SignInPage` and `SignUpPage` to work with the updated controller logic, ensuring correct usage of stores and state management.
   - Improved the UI flow by utilizing cached user data where applicable to enhance user experience and reduce redundant network calls.

7. Dependency Injection Setup Updates
   - Updated `locator.dart` to register the new `LocalStorageService` as a singleton, ensuring consistent usage across the application.

8. Removed Deprecated or Unused Files
   - Deleted obsolete files like `firebase_storage_repository.dart` and `sign_up_store.dart` under `auth` to clean up the codebase.

These changes collectively improve the overall code structure, enhance modularity, and optimize user management and state handling across the Flutter application.


## 2024/09/03 - version: 0.1.0+4

Addition of new assets, refactoring of user model and controllers, and improvements to settings and authentication

This commit introduces several enhancements and refactors to the codebase, focusing on the user model, settings management, and new assets for the UI. Key changes include:

1. New Assets Added
   - Added multiple new image assets to `assets/images/`: `delivery_00.jpg`, `delivery_02.jpg`, `delivery_03.jpg`, `delivery_04.jpg`, `delivery_name.png`, `text2871-7.png`.
   - Updated existing image `delivery_01.jpg`.
   - Added a new SVG asset `drawing.svg` to `assets/svg/` for improved graphic representation.

2. lib/common/models/user.dart
   - Expanded `UserModel` to include `id`, `role`, and `userStatus` properties.
   - Introduced serialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`) for easier data handling and storage.
   - Added new enums `UserRole` and `UserStatus` for better role management and user status tracking.

3. lib/common/settings/app_settings.dart
   - Integrated `SharedPreferences` for persistent app settings management.
   - Added methods for initialization, loading settings, toggling brightness, and tracking admin check status.
   - Improved handling of brightness settings with `ValueNotifier`.

4. lib/common/utils/data_result.dart
   - Refactored error classes, renamed `FirebaseFailure` to `FireAuthFailure` and introduced `FireStoreFailure` for more specific error handling.

5. lib/features/home/home_controller.dart
   - Integrated `AppSettings` through dependency injection for managing app settings directly within the controller.
   - Added new methods to check if the theme is dark and toggle brightness.

6. lib/features/home/home_page.dart
   - Refactored to use a new `HomeDrawer` widget for the navigation drawer, separating concerns and improving code readability.
   - Added logout and login functionality handlers.

7. lib/features/home/widgets/home_drawer.dart
   - Created a new `HomeDrawer` widget to manage the app's navigation drawer, improving modularity and encapsulation of drawer-related logic.

8. lib/features/sign_in/sign_in_page.dart
   - Simplified imports and organized code structure for better maintainability.

9. lib/features/sign_up/sign_up_controller.dart
   - Refactored to include `MaskedTextController` for formatted phone number input.
   - Adjusted logic to handle user role assignment during the signup process.

10. lib/features/sign_up/sign_up_page.dart
    - Enhanced the signup form with additional fields and validation for role selection, phone number, and user status.
    - Improved user experience with better error handling and feedback.

11. lib/locator.dart
    - Updated service locator setup to include new dependencies and maintain proper dependency injection throughout the app.

12. lib/main.dart
    - Updated initialization process to include `AppSettings` setup for persistent storage and settings management.

13. lib/my_material_app.dart
    - Refactored imports and dependencies to streamline the app initialization and usage of shared settings.

14. lib/repository/firebase/firebase_auth_repository.dart
    - Enhanced user creation logic to set user roles dynamically based on admin checks.
    - Improved error handling and logging for authentication-related operations.

15. lib/repository/firestore/user_firestore_repository.dart
    - Introduced a new repository for handling Firestore operations related to the user, including add, set, update, delete, get, and getAll methods.

16. lib/services/firebase_service.dart
    - Simplified import statements and improved service initialization logic.

17. lib/stores/mobx/common/generic_functions.dart
    - Refactored utility functions into a common directory for better organization.

18. lib/stores/mobx/sign_in_store.dart and lib/stores/mobx/sign_up_store.dart
    - Improved store classes with better state management, validation methods, and error handling.
    - Added role management and validation for new fields such as phone number.

19. pubspec.yaml and pubspec.lock
    - Added new dependencies: `shared_preferences` for persistent storage and `get_it` for service locator.
    - Updated dependency versions and lock file to reflect the new additions and changes.

These changes collectively improve the overall functionality, user experience, and maintainability of the codebase, enhancing authentication processes, state management, and UI components.


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

