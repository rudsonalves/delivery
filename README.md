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

## 2024/09/18 - version: 0.1.13+17

Update Authentication Data, Firestore Export, Models, Widgets, Features, and State Management

This commit introduces a series of updates and enhancements across various parts of the project, including authentication data modifications, Firestore export updates, model refinements, new widgets, feature additions, and improvements to state management using MobX. Below is a comprehensive breakdown of the changes:

1. **Authentication Data (`emulator_data/auth_export/accounts.json`)**
   - **Updated User Entries:**
     - **Ricardo Mattos:**
       - Updated `passwordUpdatedAt` timestamp.
       - Added `disabled` field set to `false`.
     - **Rudson Alves:**
       - Updated `passwordUpdatedAt` timestamp.
       - Added `disabled` field set to `false`.
   - **Changes:**
     - Removed newline at the end of the file.
     - Updated `validSince` timestamps.
     - Adjusted `lastRefreshAt` timestamps to reflect recent changes.

2. **Firestore Export Metadata (`emulator_data/firestore_export/`)**
   - **Files Updated:**
     - `all_namespaces_all_kinds.export_metadata`
     - `output-0`
     - `firestore_export.overall_export_metadata`
   - **Changes:**
     - Binary files differ, indicating updates to Firestore emulator export data.

3. **Dart Models**
   - **`AddressModel` (`lib/common/models/address.dart`):**
     - **Changes:**
       - Modified `geoAddress` getter to include `complement` if available.
       - Added `isValidAddress` getter to validate essential address fields.
   - **`ClientModel` (`lib/common/models/client.dart`):**
     - **Changes:**
       - Removed commented-out `id` and `address` fields from `toMap()` and `fromMap()` methods.
       - Simplified `email` field handling.
   - **`ShopModel` (`lib/common/models/shop.dart`):**
     - **New Model:**
       - Represents a shop with fields: `id`, `userId`, `address`, `name`, and `description`.
       - Includes serialization methods: `toMap()`, `fromMap()`, and other utility methods.

4. **Widgets**
   - **`AddressCard` (`lib/components/widgets/address_card.dart`):**
     - **New Widget:**
       - Displays address information based on the `ZipStatus`.
       - Handles different states: loading, error, success, and initial.
       - Utilizes theming for consistent styling.

5. **Features**
   - **Add Client Feature (`lib/features/add_client/`):**
     - **Pages & Controllers:**
       - Updated `add_client_page.dart` to integrate the new `AddressCard` widget.
       - Refactored `add_client_controller.dart` to use `StoreFunc` for utility functions.
       - Enhanced form validation and state management using MobX.
   - **Add Shop Feature (`lib/features/add_shop/`):**
     - **Controller (`add_shop_controller.dart`):**
       - Manages shop creation and updating processes.
       - Integrates with `AddShopStore` for state management.
       - Handles initialization and disposal of controllers.
     - **Page (`add_shop_page.dart`):**
       - Developed UI for adding and updating shops.
       - Integrated `AddressCard` for address display.
       - Managed form fields and submission logic.
   - **Clients Page (`lib/features/clients/clients_page.dart`):**
     - **Changes:**
       - Removed unnecessary logging.
       - Streamlined client deletion logic.
   - **Person Data Feature (`lib/features/person_data/`):**
     - **Changes:**
       - Updated to use `PageState` instead of `Status`.
       - Integrated `StoreFunc` for utility functions.
   - **Shops Management Feature (`lib/features/stores/`):**
     - **Controller (`shops_controller.dart`):**
       - Implements `ShopsController` with methods to edit and delete shops.
       - Utilizes `ShopFirebaseRepository` for data operations.
     - **Page (`shops_page.dart`):**
       - Developed UI for managing shops.
       - Implemented list views with dismissible items for editing and deleting.
       - Added confirmation dialogs for deletion with proper error handling.

6. **State Management with MobX**
   - **Common Utilities (`lib/stores/mobx/common/store_func.dart`):**
     - **New File:**
       - Replaces the deleted `generic_functions.dart`.
       - Contains utility functions such as `itsNotEmail`, `removeNonNumber`, `validCpf`, and `fetchAddress`.
       - Defines enums `PageState` and `ZipStatus` for consistent state representation.
   - **Add Client Store (`lib/stores/mobx/add_client_store.dart`):**
     - **Changes:**
       - Refactored to use `PageState` instead of `PageStatus`.
       - Integrated `StoreFunc` for validation and address fetching.
       - Enhanced form validation logic.
       - Updated actions to manage state transitions and data processing.
   - **Add Shop Store (`lib/stores/mobx/add_shop_store.dart`):**
     - **Changes:**
       - Refactored to use `StoreFunc` for utility functions.
       - Enhanced state management for shop data.
       - Integrated address validation and coordinate fetching.
       - Implemented methods for saving and updating shops with proper error handling.
   - **Shops Store (`lib/stores/mobx/shops_store.dart`):**
     - **Changes:**
       - Updated to use `StoreFunc` for consistency.
   - **Personal Data Store (`lib/stores/mobx/personal_data_store.dart`):**
     - **Changes:**
       - Refactored to use `StoreFunc` for utility functions.
       - Updated state management to use `PageState`.
   - **Sign In & Sign Up Stores (`lib/stores/mobx/sign_in_store.dart`, `lib/stores/mobx/sign_up_store.dart`):**
     - **Changes:**
       - Updated to use `StoreFunc` for utility functions.

7. **Repositories**
   - **Address Repository (`lib/repository/firebase_store/address_firebase_repository.dart`):**
     - **New Repository:**
       - Implements `AbstractAddressClientRepository` with Firebase operations for addresses.
       - Handles adding, updating, and retrieving addresses with error management.
   - **Client Repository (`lib/repository/firebase_store/client_firebase_repository.dart`):**
     - **Refinements:**
       - Updated collection keys from `keyClient` to `keyClients` for consistency.
       - Enhanced methods to handle nested address subcollections.
       - Improved error handling with specific error codes.
   - **Shop Repository (`lib/repository/firebase_store/shop_firebase_repository.dart`):**
     - **New Repository:**
       - Implements `AbstractShopRepository` with comprehensive Firebase operations for shops.
       - Includes methods for adding, updating, deleting, fetching, and streaming shops.
       - Manages nested address subcollections with proper error handling.

8. **Dependency Management**
   - **`pubspec.yaml`:**
     - **Added Dependency:**
       - `material_symbols_icons: ^4.2785.1` for enhanced iconography.
   - **`pubspec.lock`:**
     - Included `material_symbols_icons` package with version `4.2785.1`.

9. **Application Configuration (`lib/my_material_app.dart`)**
   - **Route Management:**
     - Imported new pages: `AddShopPage`.
     - Registered new routes for adding and editing shops.
     - Updated navigation logic to pass `ShopModel` arguments.

10. **Miscellaneous**
    - **Deletion of `generic_functions.dart` (`lib/stores/mobx/common/generic_functions.dart`):**
      - Removed the file in favor of the new `store_func.dart` for better organization and utility function management.
    - **Store Initialization and Disposal:**
      - Enhanced controllers to initialize with existing data when editing and properly dispose of controllers to prevent memory leaks.

11. **Firestore Security Rules (`firestore.rules`)**
    - **Note:**
      - While not directly modified in this diff, the comprehensive updates to models and repositories imply that security rules may need to be reviewed to accommodate new data structures and access patterns.

12. **Testing and Validation**
    - **Changes:**
      - Updated models and state management to ensure data integrity and proper validation across forms.
      - Enhanced error messages and state transitions to provide better user feedback.

These updates collectively enhance the application's functionality by introducing shop management features, improving form validations, refactoring utility functions for better maintainability, and strengthening state management with MobX. The introduction of new repositories ensures robust data handling with Firebase, while the addition of new widgets like `AddressCard` improves the user interface and experience.


## 2024/09/17 - version: 0.1.12+16

Update Project Configurations, Firestore Rules, and Dependencies

This commit introduces a comprehensive set of updates and enhancements to the project, including configuration adjustments, Firestore security rule enhancements, the addition of new features and models, and updates to dependencies.

1. .gitignore
   - Added Patterns:
     - `*~`: Ignores temporary backup files.
     - `.vscode/`: Includes VS Code configurations in version control.
     - iOS build artifacts:
       - `/ios/Pods/`
       - `/ios/Flutter/Flutter.framework`
       - `/ios/Flutter/Flutter.podspec`
       - `/ios/Flutter/Generated.xcconfig`
       - `/ios/Flutter/app.flx`
       - `/ios/Flutter/app.zip`
       - `/ios/Flutter/engine`
       - `/ios/Flutter/flutter_assets`
       - `/ios/ServiceDefinitions.json`
     - Firebase and Crashlytics related files:
       - `firebase_app_id_file.json`
       - `crashlytics-build.properties`
       - `serviceAccountKey.json`
       - Firebase Emulator logs and data:
         - `firebase-debug.log`
         - `firestore-debug.log`
         - `database-debug.log`
         - `ui-debug.log`
         - `storage-debug.log`
         - `firebase-debug.*`
         - `*-debug.log`
         - `emulator_data/`
     - Node.js related:
       - `node_modules/`
     - Environment variables:
       - `.env.*`
   - Removed Patterns:
     - Commented out exclusion for `.vscode/` to include it in version control.
     - Changed `/build/` exclusion to include the `build/` directory.
   - Other Adjustments:
     - Added exclusions for various IDEs and build tools.

2. Makefile
   - Changes:
     - Modified the `firebase_emu_make_cache` target to remove the `./emulator_data` directory before exporting Firebase emulators. This ensures a clean state during emulator exports.
     - Before: `firebase emulators:export ./emulator_data`
     - After: `rm -rf ./emulator_data; firebase emulators:export ./emulator_data`

3. Documentation
   - Renamed File:
     - Moved `Projeto Delivery Scrum.md` to `doc/Projeto_Delivery_Scrum.md` for better organization.

4. Firebase Authentication Data
   - Updated `accounts.json`:
     - Added new user entries with roles and authentication details for Ricardo Mattos and Rudson Alves.

5. Firestore Security Rules (`firestore.rules`)
   - Added Helper Functions:
     - `isAdmin()`: Checks if the user has an admin role.
     - `isBusiness()`: Checks if the user has a business role.
     - `isShopOwner(shop)`: Verifies if the user owns the shop.
     - `canAccessShop(shop)`: Determines if the user can access the shop based on role and ownership.
     - `isAuth()`: Checks if the user is authenticated.
   - Defined Rules for Collections:
     - `appSettings` Collection:
       - Allows creation and read access with specific restrictions.
     - `clients` Collection:
       - Admins (`role 0`): Full read and write access.
       - Business Users (`role 1`): Can read, create, and update but not delete.
       - Others: Can only read.
     - `addresses` Subcollection within `clients`:
       - Mirrors permissions of the `clients` collection.
     - `shops` Collection:
       - Read Access: Available to all authenticated users.
       - Create Access: Admins or business users creating shops associated with their user ID.
       - Update & Delete Access: Restricted to admins or business users who own the shop.
     - `addresses` Subcollection within `shops`:
       - Read Access: Based on shop access permissions.
       - Create & Update Access: Admins or business users who own the shop.
       - Delete Access: Based on shop access permissions.

6. Dart Models
   - `AddressModel` (`lib/common/models/address.dart`):
     - Removed the commented-out `id` field from the `toMap()` method.
     - Updated the `fromMap` factory constructor to handle optional `id`.
   - `ShopModel` (`lib/common/models/shop.dart`):
     - New Model: Represents a shop with fields such as `id`, `userId`, `address`, `name`, and `description`.
     - Serialization Methods: Includes `toMap()`, `fromMap()`, `toJson()`, `fromJson()`, and `copyWith()` for easy data manipulation.
   - `UserModel` (`lib/common/models/user.dart`):
     - Extended Enum: Added `manager` role to `UserRole` enum.
     - Updated Display: Handles the `manager` role with appropriate titles and icons.

7. Flutter Features
   - Add Client Feature (`lib/features/add_client/`):
     - Pages & Controllers:
       - Updated imports and dependencies.
       - Removed hardcoded `addressTypes` array.
       - Implemented form validation and state management using MobX.
       - Updated UI components to reflect state changes.
   - Add Delivery Feature (`lib/features/add_delivery/`):
     - New Pages & Controllers:
       - Added `add_delivery_controller.dart` and `add_delivery_page.dart` with basic scaffolding for delivery requests.
   - Add Shop Feature (`lib/features/add_shop/`):
     - New Pages & Controllers:
       - Added `add_shop_controller.dart` and `add_shop_page.dart` with form fields for adding shops.
       - Implemented MobX store `AddShopStore` for managing shop data and state.
   - Delivery Request Feature (`lib/features/delivery_request/`):
     - New Pages & Controllers:
       - Added `delivery_request_controller.dart` and `delivery_request_page.dart` to handle delivery requests.
   - Home Feature (`lib/features/home/`):
     - Controller (`home_controller.dart`):
       - Added getters `isAdmin` and `isBusiness` to determine user roles.
     - Page (`home_page.dart`):
       - Imported new pages for delivery requests and store management.
       - Added navigation methods `_deliceryRequest` and `_storesPage`.
     - Drawer (`home_drawer.dart`):
       - Imported `material_symbols_icons`.
       - Added conditional `ListTile` widgets for delivery requests and store management based on user roles.

8. Person Data Feature (`lib/features/person_data/`):
   - Page (`person_data_page.dart`):
     - Updated to use `PageState` instead of `PageStatus`.
     - Integrated error handling based on the updated state management.
   - Store (`personal_data_store.dart`):
     - Replaced `Status` enum with `PageState`.
     - Updated observables and actions to align with the new state management.
     - Enhanced validation methods for form fields.

9. Shops Management Feature (`lib/features/stores/`):
   - Controller (`shops_controller.dart`):
     - Implemented `ShopsController` with references to `ShopsStore` and `ShopFirebaseRepository`.
     - Added role-based getters `isAdmin` and `isBusiness`.
   - Page (`shops_page.dart`):
     - Developed `ShopsPage` with UI for managing shops.
     - Implemented list views with dismissible items for editing and deleting shops.
     - Integrated loading states and empty state handling.
   - Store (`shops_store.dart`):
     - Created `ShopsStore` with observable `state` and actions to manage shop-related states.

10. Repositories
    - Abstract Repositories:
      - `abstract_address_repository.dart`:
        - Renamed methods for consistency (`set` to `add`).
        - Updated `get` method signature to accept `addressId` instead of an `AddressModel`.
      - `abstract_shop_repository.dart`:
        - New Abstract Class: Defines methods for adding, updating, deleting, fetching, and streaming shops.
    - Concrete Repositories:
      - `address_firebase_repository.dart`:
        - Implemented `AbstractAddressClientRepository` with Firebase operations for addresses.
        - Added error handling and logging.
      - `client_firebase_repository.dart`:
        - Refactored to use `keyClients` and `keyAddresses` for collection names.
        - Enhanced methods to align with updated repository structure.
        - Improved error handling with specific error codes.
      - `shop_firebase_repository.dart`:
        - New Repository: Implements `AbstractShopRepository` with comprehensive Firebase operations for shops.
        - Includes methods for adding, updating, deleting, fetching, and streaming shops.
        - Handles nested address subcollections with proper error management.

11. Dependency Management
    - `pubspec.yaml`:
      - Added dependency: `material_symbols_icons: ^4.2785.1` for enhanced iconography.
    - `pubspec.lock`:
      - Included `material_symbols_icons` package with version `4.2785.1`.

12. Application Configuration (`lib/my_material_app.dart`)
    - Route Management:
      - Imported new pages: `add_delivery_page.dart`, `add_shop_page.dart`, `delivery_request_page.dart`, and `shops_page.dart`.
      - Registered new routes for the added pages to enable navigation within the app.

13. Common Utilities (`lib/stores/mobx/common/generic_functions.dart`)
    - Enums Added:
      - `PageState`: Represents the state of a page (initial, loading, success, error).
      - `ZipStatus`: Represents the status of ZIP code validation and fetching.
    - Constants:
      - `addressTypes`: List of address types used across the application.

14. State Management with MobX
    - Add Client Store (`lib/stores/mobx/add_client_store.dart`):
      - Refactored to use `PageState` instead of `PageStatus`.
      - Enhanced validation methods and state handling.
    - Add Shop Store (`lib/stores/mobx/add_shop_store.dart`):
      - Implemented observables and actions for managing shop data.
      - Integrated ZIP code validation and address fetching.
    - Shops Store (`lib/stores/mobx/shops_store.dart`):
      - Managed the state of shops listing and operations.
    - Personal Data Store (`lib/stores/mobx/personal_data_store.dart`):
      - Updated to use `PageState` for managing personal data states.
      - Enhanced form validation and error handling.

15. Firestore Data Export Metadata
    - Updated Export Metadata Files:
      - Differences in `emulator_data/firestore_export/` indicate updates to Firestore emulator export data.

16. Storage Rules (`storage.rules`)
    - New Rules:
      - Deny all read and write operations to Firebase Storage to enhance security.

These updates collectively improve the application's security, scalability, and maintainability. The addition of new features like shop and delivery request management expands the app's functionality, while the enhancements to Firestore rules ensure robust access control. Dependency updates and state management refinements contribute to a more stable and efficient development workflow.


## 2024/09/16 - version: 0.1.11+15

Update project configurations, Firestore rules, and dependencies

This commit introduces several updates and enhancements to the project, including configuration changes, Firestore rules updates, and additional dependencies.

1. emulator_data/auth_export/accounts.json
   - Updated the `users` array by adding a new user with detailed authentication information.

2. emulator_data/firebase-export-metadata.json
   - Added `storage` section with version `13.17.0` and path `storage_export`.

3. emulator_data/firestore_export/all_namespaces/all_kinds/all_namespaces_all_kinds.export_metadata
   - Added new export metadata file.

4. emulator_data/firestore_export/all_namespaces/all_kinds/output-0
   - Added new output file for Firestore export.

5. emulator_data/storage_export/buckets.json
   - Created `buckets.json` with bucket ID `delivery-16712.appspot.com`.

6. firebase.json
   - Added `storage` and `remoteconfig` emulators with respective ports.
   - Updated ignore patterns and added storage rules configuration.

7. firestore.rules
   - Defined rules for `appSettings` collection, including creation, read, and restriction on updates/deletes.
   - Updated `adminConfig` document rules to allow creation and read access while blocking modifications.
   - Enhanced `clients` and `addresses` collections with role-based permissions for administrators and business users.

8. lib/components/widgets/base_dismissible_container.dart
   - Changed `disableColor` from `outline` to `secondaryContainer` in the dismissible container.

9. lib/features/clients/clients_controller.dart
   - Imported `user.dart`, `user_store.dart`, and `data_result.dart`.
   - Added `userStore` locator and getters `user`, `isAdmin`, and `isBusiness`.
   - Implemented `deleteClient` method to handle client deletion.

10. lib/features/clients/clients_page.dart
    - Imported `app_text_style.dart` and `state_loading.dart`.
    - Modified `_deleteClient` to return a boolean and added a confirmation dialog.
    - Enhanced UI to conditionally display clients or a loading state.

11. lib/repository/firebase_store/client_firebase_repository.dart
    - Changed the collection key from `keyAddress` to `keyClient` when updating client data.

12. lib/services/geolocation_service.dart
    - Removed unnecessary `foundation.dart` import.
    - Eliminated debug code mocking latitude and longitude.
    - Updated `googleApi` getter to asynchronously fetch the API key.

13. lib/services/remote_config.dart
    - Imported `flutter_dotenv`.
    - Modified `googleApi` getter to load from `.env` in debug mode.

14. lib/stores/mobx/add_client_store.dart
    - Added `id` to the `ClientModel` constructor.
    - Commented out direct assignment of `client.id`.

15. lib/stores/user/user_store.dart
    - Added `isAdmin` and `isBusiness` getters to determine user roles.

16. package-lock.json
    - Added new dependencies: `@eslint/config-array`, `@eslint/object-schema`, `glob`, `rimraf`, and others.
    - Removed `optional` flags from certain dependencies.

17. package.json
    - Included new dependencies: `@eslint/config-array`, `@eslint/object-schema`, `glob`, and `rimraf`.

18. pubspec.lock
    - Added `flutter_dotenv` dependency.

19. pubspec.yaml
    - Added `flutter_dotenv` to dependencies.
    - Included `.env` file in assets.

20. remoteconfig.template.json
    - Configured `google_api_key` parameter with a default value.
    - Added version description for emulator configuration.

21. storage.rules
    - Created new storage rules to deny all read and write operations.

These changes improve security, configuration management, and functionality across various components.


## 2024/09/13 - version: 0.1.10+14

Adjusted cleartext traffic setting and added email verification resend functionality

This commit introduces changes in the AndroidManifest for debugging purposes and includes a new feature for resending email verification on the sign-in page.

1. `android/app/src/main/AndroidManifest.xml`
   - Changed `android:usesCleartextTraffic` from `false` to `true` to allow unencrypted traffic, which is useful for debugging in a local environment.

2. `lib/features/sign_in/sign_in_controller.dart`
   - Added `resendVerificationEmail()` method to resend the verification email to the user.
   
3. `lib/features/sign_in/sign_in_page.dart`
   - Added `_resendVerifEmail()` method to handle the action of resending the email verification.
   - Included a `TextButton` to trigger the resend email functionality on the sign-in page.

4. `lib/main.dart`
   - Re-enabled logging and connection to Firebase emulators in `kDebugMode`, including authentication, Firestore, and Firebase Functions emulators.

5. `lib/repository/firebase/firebase_auth_repository.dart`
   - Introduced a check to prevent multiple admin users by adding error handling for creating new admin users if one already exists.
   - Refactored the `create()` method to use a local `firebaseUser` variable for easier access and management.
   - Added a `_deleteFirebaseUser()` method to remove a user in case of an error during user creation.
   - Enhanced error handling for setting user claims and checking admin status.
   - Ensured `getUserFrom()` method reloads the user data to retrieve the latest user information.

This update improves the system by allowing email verification to be resent and refining error handling for user creation, particularly for administrative accounts.


## 2024/09/12 - version: 0.1.09+13

Add Firebase Functions for User Claims and remove `users` collection

Firebase Functions were added to manage User Claims, storing the `role` and `status` attributes of users. This replaces the need for a `users` collection. Adjustments were also made to the Firebase emulator setup to accommodate these changes.

1. Makefile
   - Added `firebase_emu_make_cache` target to export emulator data using Firebase emulators.

2. firebase.json
   - Added configuration for the Functions emulator, setting the port to 5001.
   - Included Firebase Functions deployment setup, specifying the `nodejs18` runtime and adding ignored directories like `node_modules` and `.git`.

3. firestore.rules
   - Removed `users` collection access checks since user attributes are now handled via Custom Claims.
   - Updated rules to allow any user to create new users, but only admins (role = 0) can modify or delete them.
   - Simplified the `adminConfig` creation and update logic, allowing any user to create it, but restricting updates to admins.

4. lib/common/models/client.dart
   - Added `id` field to the `ClientModel` class to store Firebase UID.

5. lib/common/settings/app_settings.dart
   - Updated import paths.

6. lib/components/widgets/base_dismissible_container.dart
   - Added a new reusable widget `baseDismissibleContainer`, allowing the configuration of alignment, color, and icons for dismissible containers.

7. lib/components/widgets/custom_text_field.dart
   - Added `focusNode` and `nextFocusNode` to support focus navigation between text fields.

8. lib/features/add_client/add_cliend_page.dart
   - Refactored the page to handle client updates. Added logic to check if a client is being added or edited and adjusted the UI accordingly.
   - Replaced `_save()` with `_saveClient()` method to differentiate between adding and updating clients.

9. lib/features/add_client/add_client_controller.dart
   - Added `updateClient()` method to support updating existing clients.
   - Modified `init()` to handle client updates by populating fields if a client is passed to the page.

10. lib/features/clients/clients_page.dart
    - Integrated dismissible containers to allow for editing and deleting clients directly from the list.
    - Added methods `_editClient()` and `_deleteClient()` to handle client modification and deletion actions.

11. lib/repository/firebase/firebase_auth_repository.dart
    - Removed logic related to the `users` collection.
    - Added `_setUserClaims()` method to set Firebase Custom Claims for `role` and `status`.
    - Refactored `getCurrentUser()` to retrieve user claims from Firebase instead of fetching from Firestore.

12. lib/repository/firebase_store/client_firebase_repository.dart
    - Refactored client retrieval methods to handle `id` properly when interacting with Firestore.

13. pubspec.yaml
    - Added `cloud_functions` dependency for Firebase Functions integration.

Changes were successfully applied to implement Firebase Functions for managing User Claims and removing the `users` collection.


## 2024/09/10 - version: 0.1.08+12

Improve Firebase integration and repository refactor

This commit introduces several changes and improvements related to Firebase integration, client management, and repository structure.

Modified files:

1. Makefile
   - Added `firebase_emu` command to start Firebase emulators with data import.
   - Added `firebase_emu_debug` command for starting Firebase emulators in debug mode.
   - Introduced `build_runner` command to execute Dart build runner in watch mode.

2. android/app/build.gradle
   - Loaded `keystoreProperties` for signing configurations.
   - Applied signing configurations for the release build.

3. android/app/google-services.json
   - Removed outdated `client_id` entry.

4. emulator_data/auth_export/accounts.json
   - Updated exported authentication data for the Firebase emulator.

5. lib/components/widgets/message_snack_bar.dart
   - Modified `showMessageSnackBar` to accept `TextStyle` for title and message, improving customization.

6. lib/features/add_client/add_cliend_page.dart
   - Enhanced form validation logic with `PageStatus` management.
   - Adjusted the save client flow to handle errors and show messages using `showMessageSnackBar`.

7. lib/features/add_client/add_client_controller.dart
   - Reworked save client logic to utilize the new `PageStatus` system.
   - Refactored controller to ensure compatibility with form validation changes.

8. lib/features/clients/clients_page.dart
   - Implemented `StreamBuilder` to display clients dynamically from the Firebase Firestore.

9. lib/locator.dart
   - Registered `AbstractClientRepository` and `ClientFirebaseRepository` to dependency injection.

10. lib/repository/firestore/
    - Refactored the repository structure, renaming files to `firebase_store` to reflect the Firebase store focus.
    - Added abstraction for repositories: `AbstractClientRepository` and `AbstractAddressClientRepository`.

11. lib/stores/mobx/add_client_store.dart
    - Added `PageStatus` to manage page loading state.
    - Improved error handling in the form submission process.

12. test/repository/firestore/client_firebase_repository_test.dart
    - Updated repository tests to reflect the new structure and naming conventions.

This update enhances Firebase emulator handling, improves client management with better error handling and state management, and refactors the repository structure to be more scalable and consistent.


## 2024/09/10 - version: 0.1.07+11

Added Firebase emulator setup, enhanced client repository, and integrated Remote Config for Google API key.

1. .gitignore
   - Added `.env` files to the ignore list.

2. Makefile
   - Added `firebase_emu` command for starting Firebase emulators.

3. android/app/build.gradle
   - Added Firebase Remote Config and Analytics dependencies.

4. android/app/google-services.json
   - Added Firebase Realtime Database URL.

5. android/app/src/main/AndroidManifest.xml
   - Set `android:usesCleartextTraffic="true"` for development with an emulator.

6. Firebase Emulator Data
   - Added pre-configured data for the Firebase Auth and Firestore emulators.

7. firebase.json
   - Updated emulator ports and added configuration for Remote Config.

8. firestore.rules
   - Updated Firestore rules to include user roles (`admin`, `business`, `delivery`) and subcollection permissions for `clients` and `addresses`.

9. Cloud Functions
   - Initialized Python-based Firebase Cloud Functions setup.

10. lib/common/models/address.dart
    - Added `geoAddress` getter for geolocation and moved `toMap` method.

11. lib/common/models/client.dart
    - Added error handling and updates for address management.

12. lib/features/add_client/add_cliend_page.dart
    - Added functionality to save clients with geolocation.

13. lib/features/add_client/add_client_controller.dart
    - Implemented saving logic for client creation with Firebase Firestore.

14. lib/main.dart
    - Integrated Firebase emulator setup for development.

15. lib/repository/firebase/firebase_auth_repository.dart
    - Updated Firebase authentication error codes.

16. lib/repository/firestore/client_firebase_repository.dart *(New)*
    - Added methods to manage clients in Firebase Firestore, including adding, updating, and deleting clients.

17. lib/services/geolocation_service.dart *(New)*
    - Added geolocation service to retrieve coordinates from a Google API for client addresses.

18. lib/services/remote_config.dart *(New)*
    - Added Firebase Remote Config integration to fetch Google API key.

19. lib/stores/mobx/add_client_store.dart
    - Integrated geolocation for addresses during client creation.

20. Firebase Remote Config
    - Added template for remote configuration in `remoteconfig.template.json`.

21. Tests
    - Created tests for `ClientFirebaseRepository` using Firebase emulators.

This commit introduces Firebase emulator setup, extends Firestore client repository functionalities, and integrates Firebase Remote Config for managing Google API keys, along with comprehensive tests.


## 2024/09/06 - version: 0.1.6+10

Refactored and improved address management, added client-related features, and enhanced UI components.

1. lib/common/models/address.dart
   - Renamed file from `adreess.dart` to `address.dart`.
   - Updated `addressString` method to use "Endereço" and handle cases where the address number is not provided (`S/N` for "sem número").

2. lib/common/models/client.dart
   - Updated the import of `address.dart` after the file rename.

3. lib/common/theme/app_text_style.dart
   - Added `font12Height` text style with adjustable line height.

4. lib/features/add_client/add_cliend_page.dart *(New File)*
   - Created the `AddCliendPage` for adding clients, with fields for name, email, phone, and address.
   - Added dropdown for address type selection and error handling for invalid inputs.

5. lib/features/add_client/add_client_controller.dart *(New File)*
   - Created the `AddClientController` to manage state and handle form inputs for the client creation page.

6. lib/features/clients/clients_controller.dart *(New File)*
   - Created a simple controller `ClientsController` with an `init` method for the clients page.

7. lib/features/clients/clients_page.dart *(New File)*
   - Created the `ClientsPage` to display a list of clients and a button to add new clients.

8. lib/features/home/home_page.dart
   - Added the `_clients` method to navigate to the `ClientsPage`.
   - Updated the `HomeDrawer` to include a "Clientes" option.

9. lib/features/home/widgets/home_drawer.dart
   - Updated `HomeDrawer` to include a `ListTile` for navigating to the clients section.

10. lib/my_material_app.dart
    - Added routes for `ClientsPage` and `AddCliendPage`.

11. lib/stores/mobx/add_client_store.dart *(New File)*
    - Created the `AddClientStore` using MobX to manage the state of the client form, including address validation via the ViaCep API.
    - Added error handling and validation for name, email, phone, and CPF.

12. lib/stores/mobx/personal_data_store.dart
    - Updated the import of `address.dart` after the file rename.

This commit introduces a new client management feature, improves address handling, and adds several new UI components and stores for better form validation and data handling.


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

