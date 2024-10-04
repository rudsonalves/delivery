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

## 2024/10/04 - version: 0.6.15+37

This commit introduces various changes to the `AddClient` and `AddShop` features, refactoring code to improve state management, centralizing common operations, and enhancing the user experience.

**Files Modified:**

1. **`lib/features/add_client/add_cliend_page.dart`**
- **File Import Refactor:**
  - Changed all imports to use relative paths (`import '/common/...'`) to ensure consistency across the project.
- **Improved Routing:**
  - Updated route name for better readability: `'addclient'` to `'add_client'`.
- **Navigation Improvement:**
  - Enhanced back navigation handling, ensuring the page only pops when mounted and passes the updated client model.
- **Dropdown Handling:**
  - Added `null` check before updating `addressType` to avoid potential runtime errors.

2. **`lib/features/add_client/add_client_controller.dart`**
- **Dependency Injection:**
  - Utilized `AbstractClientRepository` for repository abstraction, enabling better testing and flexibility.
- **Refactored Address Handling:**
  - Introduced getter method for `address` to fetch it directly from the store.
  - Added a reaction to update the address when `resetAddressString` changes, ensuring the UI is always in sync with state changes.
- **Enhanced Error Handling:**
  - Provided more descriptive error messages for connectivity issues and invalid ZIP codes.
- **Memory Management:**
  - Included a disposer for the reaction to prevent memory leaks.

3. **`lib/features/add_client/stores/add_client_store.dart`**
- **Store State Refactoring:**
  - Removed the redundant `address` observable and consolidated its state management in a single place.
  - Added actions to handle setting and resetting address strings and states (`setAddressString`, `toogleAddressString`).
  - Improved observability of `resetAddressString` and `resetZipCode` flags to centralize their usage.

4. **`lib/features/add_shop/add_shop_controller.dart`**
- **Removed Redundant Getters:**
  - Removed `isEdited`, `isValid`, and `state` getters to simplify code access. These can be directly accessed through the store.
- **Improved Error Handling:**
  - Introduced clearer error messages for ZIP code validation failures, differentiating between connectivity and invalid format errors.

5. **`lib/features/add_shop/add_shop_page.dart`**
- **File Import Refactor:**
  - Changed all imports to use relative paths (`import '/common/...'`) for consistency.
- **Simplified Store Access:**
  - Replaced direct controller state access (`ctrl`) with store references for attributes like `isValid` and `isEdited`.
- **UI Enhancement:**
  - Added dynamic titles based on the mode (`Adicionar Loja` vs. `Editar Loja`).

6. **`lib/features/add_shop/stores/add_shop_store.dart`**
- **State Correction:**
  - Fixed an incorrect reset action (`resetZipCodeChanged`) to properly update the `zipCodeChanged` state instead of `updateGeoPoint`.

This commit brings structural and state management improvements to the `AddClient` and `AddShop` features, providing better code maintainability, improved state handling, and enhanced error feedback mechanisms.


## 2024/10/04 - version: 0.6.14+36

This commit refactors the `AddDelivery` feature, improving the controller and state management, introducing a modular structure with reusable components, and enhancing error handling and UI consistency.

## Files Modified

1. **`lib/features/add_delivery/add_delivery_controller.dart`**
- **Simplified Initialization:**
  - Removed the redundant `refreshShops()` call during initialization.
  - Adjusted state handling in `setShopId` based on shop availability.
  - Set shop state after retrieving shops and updated the list of shops in the store.

2. **`lib/features/add_delivery/add_delivery_page.dart`**
- **UI Handling Enhancements:**
  - Improved navigation handling when creating a delivery. The page now only closes upon successful creation.
  - Refactored loading and error state handling into the new `ErrorCard` widget.
  - Replaced inline main content rendering logic with a new modular widget `BuildMainContentForm`.

3. **`lib/features/add_delivery/stores/add_delivery_store.dart`**
- **State Management Improvements:**
  - Added `reset()` action to clear the store state, ensuring a clean slate on initialization.
  - Updated `setShops()` to set `noShopsState` based on the shop list content.

### Files Added

4. **`lib/features/add_delivery/widgets/build_main_content_form.dart`**
- **Modularized Main Content:**
  - Extracted main content rendering logic from `AddDeliveryPage` into a separate widget for better maintainability and modularity.
  - Manages the shop selection, client search, and client list display functionalities.

5. **`lib/features/add_delivery/widgets/error_card.dart`**
- **Reusable Error Card:**
  - Created a reusable `ErrorCard` widget to standardize error handling and display across the feature.
  - Supports custom title, message, icon, and color parameters for flexibility.

This commit refactors the `AddDelivery` feature by separating concerns into distinct widgets, enhancing state management, and improving code readability. These changes make the codebase more maintainable and the UI more responsive and user-friendly.


## 2024/10/04 - version: 0.6.13+35

This commit introduces enhancements to the `ClientModel` and `ShopModel` classes for JSON serialization and deserialization. It also improves address handling in the `AddShopController`, refactors the shop repository methods to use streams, and restructures the shop management flows based on the user roles. Additional UI adjustments were made for better consistency and functionality.

**Files Modified:**

1. **`lib/common/models/client.dart`**
- **Enhanced Serialization and Deserialization:**
  - Added logic to handle `geopoint` serialization and deserialization in the `toJson` and `fromJson` methods.
  
2. **`lib/common/models/shop.dart`**
- **Improved fromJson Logic:**
  - Adjusted the `fromJson` method to retain the `geopoint` information during deserialization.

3. **`lib/features/add_shop/add_shop_controller.dart`**
- **Address Handling Refactor:**
  - Included a check to handle updates on the `GeoPoint` based on flag `updateGeoPoint`.
  - Added `resetUpdateGeoPoint()` call after updating the address geolocation.

4. **`lib/features/add_shop/add_shop_page.dart`**
- **UI Adjustments:**
  - Improved code formatting for better readability and consistency.
  - Changed `TextCapitalization.sentences` to `TextCapitalization.words` in the description field.

5. **`lib/features/add_shop/stores/add_shop_store.dart`**
- **State Management Enhancements:**
  - Added new observable state and actions for handling address type updates and other field changes.

6. **`lib/features/shops/shops_controller.dart`**
- **Role-Based Data Retrieval:**
  - Implemented role-based shop retrieval methods (`streamShopAll`, `streamShopByOwner`, `streamShopByManager`).
  - Enhanced data flow based on the logged-in user role to segregate data access.

7. **`lib/features/shops/shops_page.dart`**
- **Minor UI Updates:**
  - Improved modal and navigation actions for better user experience.

8. **`lib/repository/firebase_store/abstract_shop_repository.dart`**
- **Interface Update:**
  - Refined the abstract repository to include new streaming methods for `ShopModel` data retrieval.

9. **`lib/repository/firebase_store/shop_firebase_repository.dart`**
- **Method Implementation:**
  - Added `streamShopAll`, `streamShopByManager`, and `streamShopByOwner` methods for real-time shop data retrieval.
  - Removed redundant `getShopByName` method.

This commit streamlines data handling and serialization processes for `ClientModel` and `ShopModel`, enhances UI components for better usability, and implements role-based data access within the shop management features.


## 2024/10/03 - version: 0.6.12+34

Refactoring models and geolocation functions

**Summary**: This commit implements a refactor for the address and client models, optimizing the geolocation functions and making code cleaner by removing redundant services and controllers.

**Details**:
1. **`lib/common/models/address.dart`**
   - Removed `geolocation_service.dart` import.
   - Added `geohash` field and updated constructor accordingly.
   - Adjusted `createdAt` and `updatedAt` fields to be optional.
   - Removed `updateLocation()` method, as it's now handled externally.

2. **`lib/common/models/client.dart`**
   - Changed `geopoint` to a non-nullable field.
   - Added `geohash` field and updated all necessary methods to include it.
   - Updated constructor to assign default values to `createdAt` and `updatedAt`.

3. **`lib/common/models/delivery.dart`**
   - Fixed typo in the `geohash` field name.

4. **`lib/common/models/shop.dart`**
   - Modified `geopoint` to a required field.
   - Added `geohash`, `createdAt`, and `updatedAt` fields.

5. **`lib/common/utils/address_functions.dart`**
   - New utility class `AddressFunctions` created for geolocation-related methods, including:
     - `createAddress()`: Creates a new `AddressModel` and updates its location.
     - `updateAddressGeoLocation()`: Updates geolocation and timestamps.
     - `createGeoPointHash()`: Generates a geohash for a given `GeoPoint`.
     - `getGeoPointFromAddressString()`: Fetches `GeoPoint` based on the address string using `geocoding` package.

6. **`lib/components/widgets/address_card.dart`**
   - Replaced `AddressModel` parameter with `addressString` for better compatibility.

7. **Controllers and Stores**
   - Modified address and shop controllers to use the new `AddressFunctions` methods.
   - Removed outdated `reaction` mechanisms and added flag management (`zipCodeChanged`, `updateGeoPoint`) for reactivity.
   - Refactored `init()` and `mountAddress()` methods in `add_client` and `add_shop` controllers.

8. **Other changes:**
   - Renamed and moved `store_func.dart` for better modularization.
   - Deleted `geo_point_funcs.dart` as it is now part of `AddressFunctions`.
   - Deleted `nearby_deliveries` feature files, replaced by `user_delivery` functionalities.
   - Adjusted all imports and dependencies to reflect these changes.

This refactor improves the maintainability and organization of the project by consolidating similar functionality and removing redundancy. The changes ensure that geolocation handling is more robust and integrated directly into model creation and update methods.


## 2024/10/03 - version: 0.6.11+33

Refactored Geo-Location Attributes and Standardized Geohash Key Naming

1. **Address Model Update:**
   - Renamed `location` attribute to `geopoint` for better semantic clarity.
   - Updated all references to `location` in `AddressModel` to `geopoint`.

2. **Client Model Update:**
   - Renamed `location` attribute to `geopoint` to maintain consistency with the Address model.
   - Updated all `location` references to `geopoint` across the ClientModel.

3. **Delivery Model Update:**
   - Renamed `location` attribute to `geopoint` and `geoHash` to `geohash`.
   - Updated references in DeliveryModel to reflect these changes.

4. **Shop Model Update:**
   - Renamed `location` attribute to `geopoint` for consistency with other models.
   - Updated all relevant references.

5. **Controller and Page Updates:**
   - Refactored controllers (`add_client_controller.dart`, `add_delivery_controller.dart`, `add_shop_controller.dart`) to use the new attribute names.
   - Adjusted `MapPage` and other dependent views to reflect the renamed attributes.

6. **Nearby Deliveries Feature Refactor:**
   - Renamed `neaby_deliveries` feature to `nearby_deliveries` for correct spelling.
   - Updated controllers and store references to the new directory and file names.

7. **Repository Updates:**
   - Refactored geohash key reference in `DeliveriesFirebaseRepository` and `LocationService` from `geoHash` to `geohash`.
   - Standardized all geospatial query and data handling logic to use `geopoint` and `geohash` consistently.

8. **Other Refactoring:**
   - Adjusted json serialization methods for `ShopModel` to use `geopoint` instead of `location`.
   - Enhanced logging messages to improve debugging information during geospatial queries and updates.

This commit refines the geolocation attributes for better clarity and consistency across the models, repositories, and services. Additionally, it corrects naming inconsistencies and updates the project structure to improve maintainability and semantic accuracy.


## 2024/10/02 - version: 0.6.10+32

Refactored Directory Structure for Stores and Controllers in `features` Module

1. **Renamed and Moved Store Files:**
   - Moved store files from `lib/stores/pages/` to `lib/features/{feature_name}/stores/`.
   - Updated imports across controllers and pages to reflect new paths for store files.
   - This change affects the following stores:
     - `account_store.dart`
     - `add_client_store.dart`
     - `add_delivery_store.dart`
     - `add_shop_store.dart`
     - `clients_store.dart`
     - `home_store.dart`
     - `nearby_deliveries_store.dart`
     - `personal_data_store.dart`
     - `shops_store.dart`
     - `sign_in_store.dart`
     - `sign_up_store.dart`
     - `user_admin_store.dart`
     - `user_business_store.dart`
     - `user_delivery_store.dart`
     - `user_manager_store.dart`

2. **Updated Imports and Dependencies:**
   - Updated all controller and page imports to reference the new paths for store files.
   - Adjusted the import statements for each affected file to ensure compatibility with the new structure.

3. **Renamed `use_delivery` Feature to `user_delivery`:**
   - Renamed `lib/features/use_delivery/` to `lib/features/user_delivery/` to maintain consistency in feature naming.
   - Updated all related imports to reflect this name change.

4. **Refactored Controllers and Pages:**
   - Updated the following controllers and pages to accommodate the new store file structure:
     - `account_controller.dart`
     - `account_page.dart`
     - `add_client_controller.dart`
     - `add_client_page.dart`
     - `add_delivery_controller.dart`
     - `add_delivery_page.dart`
     - `add_shop_controller.dart`
     - `add_shop_page.dart`
     - `clients_controller.dart`
     - `clients_page.dart`
     - `home_store.dart`
     - `neaby_deliveries_controller.dart`
     - `neaby_deliveries_page.dart`
     - `person_data_controller.dart`
     - `shops_controller.dart`
     - `shops_page.dart`
     - `sign_in_controller.dart`
     - `sign_up_controller.dart`
     - `user_admin_controller.dart`
     - `user_admin_page.dart`
     - `user_business_controller.dart`
     - `user_business_page.dart`
     - `user_delivery_controller.dart`
     - `user_delivery_page.dart`
     - `user_manager_controller.dart`
     - `user_manager_page.dart`

This commit restructures the project by organizing store files within each feature module, promoting a more modular and maintainable codebase. The refactor improves readability and helps in future scalability of the project.


## 2024/10/02 - version: 0.6.09+31

Refactored Delivery and Client Controllers to Utilize Improved Repository and State Management

1. **lib/features/add_client/add_client_controller.dart**
   - Added `repository` to `AddClientController` for managing client-related operations.
   - Implemented `ClientFirebaseRepository` for client data management.

2. **lib/features/add_delivery/add_delivery_controller.dart**
   - Reorganized dependencies with final variables for repositories and user store.
   - Refactored the `createDelivery` method to handle errors and state transitions more effectively.
   - Implemented methods for searching clients and refreshing shop data using repositories.

3. **lib/features/add_delivery/add_delivery_page.dart**
   - Updated `AddDeliveryPage` to use `AddDeliveryStore` for state management and refactored controller initialization.

4. **lib/features/map/map_page.dart**
   - Added a back navigation button to improve the user experience.

5. **lib/features/person_data/person_data_controller.dart**
   - Replaced store references with user store properties for better separation of concerns.

6. **lib/features/use_delivery/user_delivery_controller.dart**
   - Integrated `UserDeliveryStore` for state management and controller initialization.

7. **lib/features/user_admin/user_admin_controller.dart**
   - Reorganized state management using `UserAdminStore`.
   - Replaced individual state properties with general state management logic.

8. **lib/features/user_business/user_business_controller.dart**
   - Integrated `UserBusinessStore` and consolidated state management.

9. **lib/repository/firebase_store/abstract_deliveries_repository.dart**
   - Added `getAll` method to fetch all deliveries in the system.

10. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
    - Implemented `getAll` method to support the retrieval of all delivery records from the database.
    - Added error handling and logging for repository operations.

11. **lib/stores/pages/add_client_store.dart**
    - Removed repository dependency to reduce coupling.

12. **lib/stores/pages/add_delivery_store.dart**
    - Updated store to use observable lists for managing clients and shops.
    - Simplified error handling and state management.

13. **lib/stores/pages/user_admin_store.dart**
    - Introduced a new state management pattern using `PageState` for consistency.
    - Replaced individual state properties with a single observable state property.

14. **lib/stores/pages/user_business_store.dart**
    - Refactored state handling methods for consistency with other stores.

15. **lib/stores/pages/user_delivery_store.dart**
    - Introduced `errorMessage` and `state` observables for better error handling and UI updates.

This commit refines the delivery and client-related features by integrating repository patterns and improving state management with MobX stores. The refactor enhances code readability, reduces coupling between controllers and stores, and improves error handling and user feedback mechanisms.


## 2024/10/01 - version: 0.6.08+30

Refactored Client and Shop-related features to improve state management and UI consistency.

1. **lib/common/models/client.dart**
   - Adjusted `copyWith` method for `address` to handle potential null values properly.

2. **lib/features/add_client/add_client_controller.dart**
   - Refactored `AddClientController` to use `AddClientStore` for better state management.
   - Introduced `_mountAddress` and `_setClientValues` methods to handle address setup.
   - Added reaction disposers for observables to manage form updates.

3. **lib/features/add_client/add_cliend_page.dart**
   - Updated page to use `AddClientStore` for state handling and input validation.
   - Replaced direct access to controller properties with store properties.

4. **lib/features/clients/clients_controller.dart**
   - Implemented stream subscription for client data using `ClientsStore`.
   - Added methods for client data retrieval and state updates.

5. **lib/features/clients/clients_page.dart**
   - Replaced `StreamBuilder` with `Observer` for MobX-based state management.
   - Improved error handling and UI state consistency using `ClientsStore`.

6. **lib/features/add_shop/add_shop_controller.dart**
   - Refined `AddShopController` to use `AddShopStore` for form management.
   - Implemented state updates and error handling through store methods.
   - Consolidated address setup methods for cleaner code structure.

7. **lib/features/add_shop/add_shop_page.dart**
   - Integrated `AddShopStore` into the page for more reactive state updates and cleaner UI logic.

8. **lib/features/shops/shops_controller.dart**
   - Refactored `ShopsController` to use `ShopsStore` for shop data management.
   - Added shop data streaming and improved error handling through store.

9. **lib/features/shops/shops_page.dart**
   - Replaced previous implementation with `Observer` for reactive UI updates.
   - Refactored `Dismissible` widgets into a separate component (`DismissibleShop`).

10. **lib/features/shops/widgets/dismissible_shop.dart**
    - Created a reusable `DismissibleShop` widget for managing shop edit/delete actions in a dismissible container.

11. **lib/stores/pages/clients_store.dart**
    - Created a new `ClientsStore` for managing client data and UI states.
    - Implemented methods for setting client data, handling errors, and state management.

12. **lib/stores/pages/shops_store.dart**
    - Updated `ShopsStore` to handle shop data and UI state more effectively.
    - Added methods for setting shop data and managing errors.

13. **lib/stores/pages/add_client_store.dart**
    - Refined `AddClientStore` by separating address and state management methods.
    - Improved form validation and error handling through store methods.

14. **lib/stores/pages/add_shop_store.dart**
    - Simplified error handling and state management by consolidating methods.

15. **lib/stores/pages/nearby_deliveries_store.dart**
    - Renamed `setPageState` to `setState` for consistency across stores.
    - Adjusted error handling methods to use the new naming convention.

This commit introduces a comprehensive refactor of Client and Shop-related features, focusing on state management improvements using MobX stores, better error handling, and UI consistency. The refactor leads to a more maintainable codebase and clearer separation of concerns between controllers and stores.


## 2024/10/01 - version: 0.6.07+29

Refactored `user_business`, `add_user_business`, and related features.

1. **lib/features/account/account_controller.dart**
   - Updated `AccountController` to use `AccountStore` for state management.
   - Implemented `getManagerShops()` method to retrieve and store manager shops locally.

2. **lib/features/account/account_page.dart**
   - Integrated `AccountStore` into `AccountPage` for state management and UI updates.
   - Replaced references to `pageStore` with `store` to reflect the new structure.

3. **lib/features/add_shop/add_shop_controller.dart**
   - Modified `AddShopController` to utilize `AddShopStore` for improved state handling.
   - Refactored methods like `saveShop()` and `updateShop()` for cleaner logic and local store updates.
   - Updated shop values initialization to correctly set store properties.

4. **lib/features/add_shop/add_shop_page.dart**
   - Adjusted page to work with `AddShopStore` for reactive state management.
   - Implemented improved error handling and display for the form fields.

5. **lib/features/user_business/user_business_controller.dart**
   - Adjusted to utilize `UserBusinessStore` for state management.
   - Refactored delivery fetching logic to use the new `getByOwnerId()` method.

6. **lib/features/user_business/user_business_page.dart**
   - Updated page to use `UserBusinessStore` for state management and reactive UI updates.

7. **lib/repository/firebase_store/abstract_deliveries_repository.dart**
   - Renamed methods like `streamDeliveryByShopId` and `getDeliveryByOwnerId` for better clarity and consistency.
   - Added new methods like `updateManagerId` to handle specific delivery updates in the repository.

8. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
   - Refactored method names to align with repository conventions (e.g., `getByShopId`, `getNearby`).
   - Implemented new method `updateManagerId` for batch updating the manager ID in delivery documents.

9. **lib/stores/pages/account_store.dart**
   - Simplified store logic by removing direct repository calls and focusing on state management.
   - Refactored state update methods for consistency.

10. **lib/stores/pages/add_shop_store.dart**
    - Separated store logic from the controller, focusing on reactive state updates and form validation.

11. **lib/stores/pages/user_business_store.dart**
    - Updated `PageState` to `state` for naming consistency across stores.
    - Added error handling and state management methods to handle various UI states.

12. **lib/stores/pages/user_manager_store.dart**
    - Integrated delivery and shop data management into `UserManagerStore`.
    - Added state and error handling methods for cleaner management of UI states.

This commit refactors and streamlines the business-related pages, controllers, and stores, introducing better state management and separation of concerns, leading to a more maintainable and consistent codebase.


## 2024/09/30 - version: 0.6.06+28

Refactored `DeliveryModel` and `UserModel` to include new fields and updated page functionality for business users.

1. **General Package Updates**
   - Updated `DeliveryModel` to include the new `ownerId` field.
   - Refactored `UserModel` by renaming the `managerId` field to `bossId` for better clarity.

2. **lib/common/models/delivery.dart**
   - Added `ownerId` field to `DeliveryModel` for better association between deliveries and their respective owners.
   - Adjusted constructors, methods, and `copyWith` pattern to accommodate the new field.

3. **lib/common/models/user.dart**
   - Renamed the `managerId` field to `bossId` throughout the class to better reflect the role hierarchy.
   - Updated all related methods and factory constructors accordingly.

4. **lib/features/user_business/user_business_controller.dart**
   - Refactored the `UserBusinessController` to properly use the `ownerId` field for querying deliveries.
   - Implemented new state management for loading and displaying deliveries specific to business users.

5. **lib/features/user_business/user_business_page.dart**
   - Modified `UserBusinessPage` to leverage the new `UserBusinessStore` for managing deliveries.
   - Added error handling and refresh functionality to improve user experience.

6. **lib/stores/pages/user_business_store.dart**
   - Added `deliveries` observable list and methods for updating deliveries in the store.
   - Implemented `pageState` observable to manage loading and error states.

7. **lib/repository/firebase_store/abstract_deliveries_repository.dart**
   - Renamed `streamDeliveryByOwnerId` to `getDeliveryByOwnerId` for better method naming consistency.

8. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
   - Updated the implementation of `getDeliveryByOwnerId` to fetch deliveries based on the new `ownerId` field.

9. **lib/stores/pages/add_delivery_store.dart**
   - Updated the delivery creation logic to include `ownerId` when creating new deliveries in the store.

10. **Other minor updates:**
    - Adjusted various field names and method calls to match the new field names (`bossId` instead of `managerId`).
    - Updated error messages and UI text to provide clearer information to the user.

This commit improves the consistency and clarity of the data models, introduces better state management for business users, and ensures that deliveries are correctly associated with their respective owners using the new `ownerId` field.


## 2024/09/30 - version: 0.6.05+27

Updated Firebase packages and implemented geolocation-based delivery features.

1. **General Package Updates**
   - Updated all Firebase-related packages to the latest versions to address compatibility issues.
   - Updated the `geoflutterfire2` package locally and began testing it to ensure it functions correctly.

2. **Android Manifest**
   - Added `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, and `ACCESS_BACKGROUND_LOCATION` permissions in the `AndroidManifest.xml` to support geolocation services in the app.

3. **lib/common/extensions/user_role_extensions.dart** (New)
   - Created `UserRoleExtensions` to add utility methods like `displayName` and `iconData` for `UserRole`.

4. **lib/common/models/user.dart**
   - Removed the deprecated `ptUserRole` method.
   - Updated code to use the new extension methods from `UserRoleExtensions`.

5. **lib/features/add_delivery/add_delivery_page.dart**
   - Added a refresh button for shops to the dropdown menu in the delivery creation form.

6. **lib/features/home/home_controller.dart**
   - Renamed `isDelivery` to `isDeliveryman` to better reflect the role's meaning.

7. **lib/features/home/home_page.dart**
   - Replaced `UserDeliveryPage` with `NearbyDeliveriesPage` in the PageView navigation.

8. **lib/features/home/widgets/custom_drawer_header.dart**
   - Updated to use the `UserRoleExtensions` for cleaner code and separation of concerns.

9. **lib/features/neaby_deliveries/neaby_deliveries_controller.dart** (New)
   - Implemented `NearbyDeliveriesController` to manage geolocation-based queries and subscriptions for nearby deliveries.

10. **lib/features/neaby_deliveries/neaby_deliveries_page.dart** (New)
    - Created a new page `NearbyDeliveriesPage` to display deliveries within a certain radius of the user's current location.

11. **lib/repository/firebase_store/abstract_deliveries_repository.dart**
    - Renamed method `getDeliveryNearby` to `getDeliveriesNearby` for naming consistency.

12. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
    - Updated the geolocation query method to include a limit on the number of results and added better error handling.

13. **lib/services/location_service.dart** (New)
    - Implemented a new `LocationService` class to handle permission requests and updating the user's location in Firestore.

14. **lib/stores/pages/add_delivery_store.dart**
    - Added the `refreshShops` method to dynamically update the list of available shops based on the user's role.

15. **lib/stores/pages/user_business_store.dart** (New)
    - Created a new MobX store for managing state in the business user page.

16. **pubspec.yaml / pubspec.lock**
    - Updated `geolocator` and added its dependencies (`geolocator_android`, `geolocator_apple`, etc.) to support geolocation in the app.

This commit introduces significant updates to geolocation-based functionality in the delivery app. It refactors user role handling, introduces new pages and controllers for managing nearby deliveries, and updates the project dependencies to ensure compatibility and stability.


## 2024/09/26 - version: 0.6.04+26

Added geoHash field to DeliveryModel and introduced geolocation-based queries for deliveries.

1. **lib/common/models/delivery.dart**
   - Added the `geoHash` field to `DeliveryModel` for more efficient geospatial queries.
   - Updated the constructor, `copyWith`, `toMap`, and `fromMap` methods to handle the new `geoHash` field.

2. **lib/common/utils/geo_point_funcs.dart** (New)
   - Created a utility function `createGeoPointHash` using the GeoFlutterFire package to generate geohashes based on a `GeoPoint`.

3. **lib/components/widgets/delivery_card.dart**
   - Renamed from `lib/features/home/widgets/delivery_card.dart` for a more general use across features.

4. **lib/features/account/account_controller.dart**
   - Renamed from `lib/features/account_page/account_controller.dart`.

5. **lib/features/account/account_page.dart**
   - Renamed from `lib/features/account_page/account_page.dart`.

6. **lib/features/add_delivery/add_delivery_controller.dart**
   - Refactored to use `store` instead of `pageStore` for consistency across the project.

7. **lib/features/add_delivery/add_delivery_page.dart**
   - Updated method references to use `store` instead of `pageStore` after the refactor.

8. **lib/features/home/home_controller.dart**
   - Added logic to dynamically set the page title based on user role (Admin, Business, Manager, Delivery).
   - Introduced a `PageController` to manage different views for different user roles.

9. **lib/features/home/home_page.dart**
   - Replaced static delivery list with a dynamic `PageView` that shows different pages based on user roles.

10. **lib/features/use_delivery/user_delivery_controller.dart** (New)
    - Created a controller for managing the delivery page specific to delivery users.

11. **lib/features/use_delivery/user_delivery_page.dart** (New)
    - Added a new page dedicated to delivery users, displaying relevant delivery information.

12. **lib/features/user_admin/user_admin_controller.dart** (New)
    - Created a controller for the admin page, managing admin-specific actions and data.

13. **lib/features/user_admin/user_admin_page.dart** (New)
    - Implemented the admin page with functionality for viewing and managing deliveries.

14. **lib/features/user_business/user_business_controller.dart** (New)
    - Created a controller for the business page, managing data relevant to business users.

15. **lib/features/user_business/user_business_page.dart** (New)
    - Implemented a business-specific page to display and manage deliveries.

16. **lib/features/user_manager/user_manager_controller.dart** (New)
    - Created a controller for the manager page, handling manager-specific actions.

17. **lib/features/user_manager/user_manager_page.dart** (New)
    - Implemented the manager-specific page to display and manage deliveries.

18. **lib/my_material_app.dart**
    - Updated routes to reflect the new structure and renamed files.

19. **lib/repository/firebase_store/abstract_deliveries_repository.dart**
    - Added methods for streaming deliveries by owner and retrieving nearby deliveries based on geolocation.

20. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
    - Integrated geospatial queries using GeoFlutterFire to stream deliveries near a specified location.
    - Added a method to stream deliveries based on owner ID.

21. **lib/repository/firebase_store/shop_firebase_repository.dart**
    - Implemented a method to get shops by owner ID.

22. **lib/services/local_storage_service.dart**
    - Added a method to clear cached manager shops when the user logs out.

23. **lib/stores/pages/add_delivery_store.dart**
    - Added logic to generate and store a geohash for the shop's location when creating a delivery.

24. **lib/stores/pages/user_admin_store.dart** (New)
    - Created MobX store for managing admin page state.

25. **lib/stores/pages/user_delivery_store.dart** (New)
    - Created MobX store for managing the delivery page state.

26. **lib/stores/pages/user_manager_store.dart** (New)
    - Created MobX store for managing the manager page state.

27. **lib/stores/user/user_store.dart**
    - Added logic to fetch and cache shops for manager and business users upon login.
    - Enhanced the logout process to clear cached data.

This commit adds geolocation-based functionality to deliveries, reorganizes user roles, and introduces distinct pages for different user types (Admin, Business, Manager, Delivery). The overall structure was refactored to support these new features.


## 2024/09/26 - version: 0.6.03+25

Introduced integration with Google Maps and improvements to delivery and shop models.

1. `android/app/src/main/AndroidManifest.xml`
   - Added meta-data for Google Maps API key for future use in map integrations.

2. `lib/common/extensions/delivery_status_extensions.dart`
   - Renamed from `emu_extensions.dart` to better reflect its purpose.
   - Imported `material_symbols_icons` package.
   - Added new `icon` getter to provide icons for different `DeliveryStatus` values.

3. `lib/common/models/delivery.dart`
   - Added `shopPhone` to `DeliveryModel` to store the phone number of the shop.
   - Renamed `shopLocation` to `location` for consistency in representing the shop's location.
   - Updated `DeliveryModel` constructor, `toMap`, `fromMap`, and comparison methods to include the new `shopPhone` and renamed fields.

4. `lib/common/models/shop.dart`
   - Renamed `userId` to `ownerId` to clarify the purpose of the field.
   - Added `phone` field to store the shop's phone number.
   - Updated `toMap`, `fromMap`, and other relevant methods to handle the new fields.

5. `lib/common/theme/app_text_style.dart`
   - Added `font14` method to support text styling for smaller fonts.

6. `lib/features/add_delivery/add_delivery_controller.dart`
   - Updated `init` method to be asynchronous, awaiting store initialization.
   - Added `noShopsState` for handling cases where no shops are available.

7. `lib/features/add_delivery/add_delivery_page.dart`
   - Added error handling for no shops and unknown errors with appropriate UI feedback.
   - Modified the delivery creation flow to reflect the new `noShopsState`.

8. `lib/features/add_shop/add_shop_controller.dart`
   - Added a `phoneController` to manage the input for shop phone numbers.

9. `lib/features/home/home_controller.dart`
   - Imported `DeliveriesFirebaseRepository` for streaming deliveries in the home page.

10. `lib/features/home/home_page.dart`
    - Integrated delivery cards that allow users to view delivery details and navigate to a map view.
    - Streamed deliveries from the repository for dynamic updates.

11. `lib/features/home/widgets/delivery_card.dart` (New)
    - Created `DeliveryCard` widget to display delivery information, including the client name, shop phone, and address.

12. `lib/features/map/map_controller.dart` (New)
    - Created `MapController` to manage Google Maps interaction.

13. `lib/features/map/map_page.dart` (New)
    - Implemented `MapPage` to display the delivery route from the shop to the client's location using Google Maps.

14. `lib/my_material_app.dart`
    - Added route generation for `MapPage` to allow users to navigate to the delivery map.

15. `lib/repository/firebase_store/shop_firebase_repository.dart`
    - Renamed `userId` to `ownerId` in Firestore queries and data handling.
    - Adjusted data map handling for consistency.

16. `lib/stores/pages/add_delivery_store.dart`
    - Added `NoShopState` enum to handle various states related to shop availability.
    - Updated the `init` method to fetch shops and handle errors accordingly.

17. `lib/stores/pages/add_shop_store.dart`
    - Added `phone` and `errorPhone` observables for managing and validating phone number input.
    - Included phone validation logic in `isValid()` method.

This commit introduces Google Maps integration and enhances the delivery flow by adding phone numbers and updating shop and delivery models. It also improves error handling and user experience when creating deliveries.


## 2024/09/25 - version: 0.6.02+24

Enhance Delivery Model and Refactor Delivery Features

1. **lib/common/models/delivery.dart**
   - Added `clientPhone` field to `DeliveryModel`.
   - Removed `deliveryDate` field from `DeliveryModel`.
   - Updated `copyWith`, `toMap`, `fromMap`, `toJson`, `fromJson`, `toString`, `==`, and `hashCode` methods to include `clientPhone` and exclude `deliveryDate`.

2. **lib/common/models/shop.dart**
   - Modified `toJson` method to include `id` and structured `location` data with latitude and longitude.
   - Updated `fromJson` factory constructor to correctly parse nested `location` data and remove redundant fields.

3. **lib/features/delivery_request/delivery_request_controller.dart**
   - **Deleted File**: Removed `DeliveryRequestController` as it is no longer needed.

4. **lib/features/delivery_request/delivery_request_page.dart**
   - **Deleted File**: Removed `DeliveryRequestPage` to streamline delivery handling within the app.

5. **lib/features/home/home_page.dart**
   - Commented out `_deliceryRequest` method and its invocation to eliminate navigation to the now-deleted `DeliveryRequestPage`.

6. **lib/features/home/widgets/home_drawer.dart**
   - Removed `deliceryRequest` parameter and associated `ListTile` for delivery requests from `HomeDrawer`.

7. **lib/my_material_app.dart**
   - Removed references to `DeliveryRequestPage` route from the application's navigation routes.

8. **lib/repository/firebase_store/deliveries_firebase_repository.dart**
   - Refactored `add` and `update` methods to utilize `WriteBatch` for atomic Firestore operations.
   - Included `clientPhone` in `DeliveryModel` during add and update operations.
   - Enhanced `get` and `getAll` methods to handle Firestore timestamps correctly and ensure proper data conversion.
   - Improved error handling and logging for delivery data management.

9. **lib/services/local_storage_service.dart**
   - Updated log messages to reflect changes in managing manager shops.
   - Added error handling in `getManagerShops` to log exceptions and ensure robustness.

10. **lib/stores/pages/add_delivery_store.dart**
    - Enhanced `createDelivery` method to include `clientPhone` and implement comprehensive error handling.
    - Initialized `shopId` with the first available shop's ID during the `init` action for default selection.
    - Updated import paths for consistency and clarity.

These changes enhance the delivery model by adding necessary fields, refactor delivery-related features for improved state management, and remove obsolete delivery request components. These updates pave the way for a more streamlined and efficient delivery registration process in the delivery app.

 
## 2024/09/25 - version: 0.6.01+23

Complete System Base and Initiate Delivery Registration Features

1. **.gitignore**
   - Added `*.old` to ignore old backup files.

2. **Makefile**
   - Renamed `firebase_emu_make_cache` target to `firebase_emusavecache` for clarity.

3. **firestore.rules**
   - Simplified Firestore security rules by removing specific access controls.
   - Updated rules to allow read and write operations on all documents at development time.

4. **lib/common/extensions/emu_extensions.dart**
   - Updated string literals in `DeliveryStatusExtension` to use single quotes for consistency.

5. **lib/common/models/address.dart**
   - Removed `createdAt` and `updatedAt` fields from `AddressModel`.
   - Refactored `updateLocation` method to use `location` instead of `geoPoint`.

6. **lib/common/models/client.dart**
   - Renamed `geoAddress` to `location` in `ClientModel`.
   - Updated related methods and JSON serialization to reflect the name change.

7. **lib/common/models/shop.dart**
   - Renamed `geoAddress` to `location` in `ShopModel`.
   - Updated related methods and JSON serialization to reflect the name change.

8. **lib/components/widgets/dismissible_help_row.dart**
   - **New File**: Added `DismissibleHelpRow` widget class to provide a consistent UI for edit and delete actions.

9. **lib/features/add_delivery/add_delivery_controller.dart**
   - Implemented `AddDeliveryController` with properties and methods for managing delivery creation.
   - Integrated `AddDeliveryStore` for state management.
   - Added text controllers for phone and name inputs with appropriate masks.

10. **lib/features/add_delivery/add_delivery_page.dart**
    - Enhanced `AddDeliveryPage` with form fields for selecting origin shop and destination client.
    - Integrated `DismissibleHelpRow` for better user interaction.
    - Added submission methods for name and phone searches.
    - Included a `BigButton` to generate deliveries.

11. **lib/features/clients/clients_page.dart**
    - Updated `ClientsPage` to use the newly created `DismissibleHelpRow` widget for editing and deleting clients.
    - Removed redundant code and streamlined the UI components.

12. **lib/features/home/home_page.dart**
    - Modified `HomePage` to include a floating action button that navigates to `AddDeliveryPage` for creating new deliveries.
    - Updated navigation imports for consistency.

13. **lib/features/shops/shops_page.dart**
    - Updated `ShopsPage` to incorporate `DismissibleHelpRow` and enhanced dismissible list items for editing and deleting shops.
    - Improved UI layout and interaction handling.

14. **lib/repository/firebase_store/client_firebase_repository.dart**
    - Refactored client repository methods (`add` and `update`) to use `WriteBatch` for atomic Firestore operations.
    - Improved error handling and logging for client data management.

15. **lib/repository/firebase_store/shop_firebase_repository.dart**
    - Refactored shop repository methods (`add` and `update`) to use `WriteBatch` for atomic Firestore operations.
    - Enhanced error handling and logging for shop data management.

16. **lib/stores/pages/add_client_store.dart**
    - Updated `AddClientStore` with changes to address updating and location handling.
    - Refactored state management variables and methods for better clarity and functionality.

17. **lib/stores/pages/add_delivery_store.dart**
    - **New File**: Added `AddDeliveryStore` class with observable properties and actions for managing delivery data.
    - Implemented search functionalities by name and phone.
    - Integrated local storage interactions for managing shops and clients.

18. **lib/stores/pages/add_shop_store.dart**
    - Modified `AddShopStore` with updates to address handling and validation.
    - Refactored methods for setting shop details and validating inputs.
    - Enhanced state management for shop creation and updates.

19. **pubspec.yaml**
    - Updated application version from `0.4.04+22` to `0.6.00+23` to reflect significant feature additions and improvements.

These changes complete the system's base functionality and lay the groundwork for developing the delivery registration feature in the delivery app.


## 2024/09/24 - version: 0.4.04+22

Complete System Base Implementation and Prepare for Delivery Registration Development

1. **lib/features/account_page/account_controller.dart**
   - Changed the `init` method to `Future<void>` and made it asynchronous.
   - Added `await pageStore.init()` within the `init` method.

2. **lib/services/local_storage_service.dart**
   - Imported `dart:developer` for logging purposes.
   - Imported `../common/models/shop.dart` to handle `ShopModel`.
   - Added `_keyManagerShops` constant for storing manager shops.
   - Implemented `setManagerShops` method to save a list of manager shops.
   - Implemented `getManagerShops` method to retrieve the list of manager shops.

3. **lib/stores/pages/account_store.dart**
   - Imported `../../services/local_storage_service.dart` to use the local storage service.
   - Added `localStore` instance using `locator<LocalStorageService>()`.
   - Created an asynchronous `init` action method to initialize the store.
   - Updated `getManagerShops` to call `setInLocalStore` after fetching shops.
   - Added `setInLocalStore` method to save shops to local storage.
   - Added `getInLocalStore` action method to load shops from local storage.

These changes complete the system's base functionality and set the foundation for developing the delivery registration feature in the delivery app.


## 2024/09/24 - version: 0.4.03+21

Refactor Models, Update Controllers, Enhance UI Components, and Improve Repository Interactions

This commit introduces a series of modifications aimed at enhancing the application's data models, controllers, user interface components, and repository layers. The changes focus on improving code maintainability, ensuring data integrity, and enhancing the overall user experience. Below is a comprehensive overview of the updates made across various files:

1. **lib/common/models/address.dart**
   
   - **Import Path Adjustment:**
     - Updated the import statement for the `geolocation_service` to use an absolute path. This change streamlines the import process, making the codebase more organized and easier to navigate.

2. **lib/common/models/client.dart**
   
   - **Field Renaming and Refactoring:**
     - Renamed the `geoAddress` field to `location` to better represent geographical data using `GeoPoint`.
     - Updated all references to this field throughout the model, including constructors, `copyWith` methods, serialization (`toMap` and `fromMap`), string representations, and equality checks.
   
   - **Data Integrity Enhancements:**
     - Ensured that the `location` field accurately reflects the geographical position by updating related methods and ensuring consistent data handling across the model.

3. **lib/features/account_page/account_controller.dart**
   
   - **Imports and Dependencies:**
     - Added imports for `ShopModel` and `store_func` to facilitate interactions with shop data and utility functions.
   
   - **State Management Enhancements:**
     - Introduced `state` and `shops` properties to manage the current state of the account page and the list of shops managed by the user.
     - Implemented the `getManagerShops` method to fetch and manage shops associated with the current user, enhancing the controller's functionality.

4. **lib/features/account_page/account_page.dart**
   
   - **Imports and Theming:**
     - Added imports for `store_func.dart` and `material_symbols_icons` to incorporate additional UI components and iconography.
     - Utilized the `colorScheme` from the theme to ensure consistent and adaptive coloring across UI elements.
   
   - **User Interface Enhancements:**
     - Introduced buttons for generating QR codes and loading managed shops, providing users with more interactive options.
     - Enhanced conditional rendering based on the page state, displaying loading indicators and lists of managed shops as appropriate.
   
   - **Icon Update:**
     - Changed the floating action button icon from a person-add symbol to a delivery-dining icon to better align with the application's delivery-focused functionality.

5. **lib/features/add_shop/add_shop_page.dart**
   
   - **Route Name Update:**
     - Changed the route name from `/add_store` to `/add_shop` to maintain consistency and clarity within the application's navigation structure.

6. **lib/features/clients/clients_controller.dart**
   
   - **Navigator Arguments Adjustment:**
     - Modified the arguments passed to the navigation method by removing the map wrapper around the `client` object. This simplification enhances the clarity and efficiency of data passing between pages.

7. **lib/features/clients/clients_page.dart**
   
   - **Imports and Widget Enhancements:**
     - Added imports for `material_symbols_icons` and a newly created `dismissible_client.dart` widget to enrich the UI and encapsulate dismissible functionalities.
   
   - **Method Additions:**
     - Introduced the `_addClient` method to streamline navigation to the Add Client page, promoting code reusability and cleaner button handlers.
   
   - **UI Refactoring:**
     - Replaced the inline `Dismissible` widgets with the reusable `DismissibleClient` widget. This change not only cleans up the UI code but also promotes better separation of concerns and easier maintenance.

8. **lib/features/clients/widgets/dismissible_client.dart** *(New File)*
   
   - **Reusable Dismissible Widget:**
     - Created the `DismissibleClient` widget to encapsulate the logic for dismissible client items. This modular approach enhances code reusability, readability, and maintainability.
   
   - **Enhanced Interaction Handling:**
     - Configured customized backgrounds for edit and delete actions within the dismissible widget, providing intuitive swipe interactions for users.

9. **lib/features/home/home_page.dart**
   
   - **Icon Update:**
     - Updated the floating action button icon from a person-add symbol to a delivery-dining icon, aligning the UI more closely with the application's delivery-centric features.

10. **lib/features/qrcode_read/qrcode_read_page.dart**
    
    - **Imports and Dependencies:**
      - Added imports for `dart:async` and `qr_flutter` to handle asynchronous operations and QR code generation/display.
    
    - **Lifecycle Management:**
      - Implemented `WidgetsBindingObserver` to manage the scanner's lifecycle effectively, ensuring that the scanner starts and stops appropriately based on the app's state (e.g., when the app is resumed or paused).
    
    - **Barcode Detection Handling:**
      - Introduced a `StreamSubscription` to listen for barcode detections, enhancing the scanner's responsiveness and reliability.
    
    - **User Interface Enhancements:**
      - Integrated `QrImageView` to display the scanned QR code data, providing users with immediate visual feedback of the scanned information.
      - Enhanced error handling and data representation to offer clearer feedback and smoother user interactions.
    
    - **Scanner Initialization:**
      - Configured the `MobileScannerController` with additional parameters to optimize scanning performance and user experience.

11. **lib/repository/firebase_store/abstract_shop_repository.dart**
    
    - **Interface Extension:**
      - Added a new method `getShopByManager` to the abstract repository interface. This method facilitates fetching shops managed by a specific manager, expanding the repository's capabilities.

12. **lib/repository/firebase_store/client_firebase_repository.dart**
    
    - **Add Method Refactoring:**
      - Enhanced the `add` method to incorporate address localization before saving a client. This ensures that each client's geographical data is accurately captured and stored.
      - Implemented checks to ensure that a client has an address before proceeding with the localization and storage processes.
    
    - **Data Integrity Enhancements:**
      - Ensured that the client's address information is properly saved within the relevant subcollection, maintaining consistent and reliable data structures.

13. **lib/repository/firebase_store/shop_firebase_repository.dart**
    
    - **Method Implementation:**
      - Implemented the `getShopByManager` method to retrieve all shops managed by a specific manager. This method queries the Firestore database and processes the results to return a list of `ShopModel` instances.
    
    - **Error Handling:**
      - Incorporated comprehensive error handling to log and manage any issues that arise during the data retrieval process, ensuring robustness and reliability.

14. **lib/stores/pages/account_store.dart**
    
    - **State Management Enhancements:**
      - Added `shops` and `state` observables to manage the list of shops and the current page state within the account store.
    
    - **Action Implementation:**
      - Developed the `getManagerShops` action to fetch shops managed by the current user. This action updates the store's state based on the success or failure of the data retrieval process, facilitating responsive UI updates.
    
    - **Repository Integration:**
      - Integrated the `ShopFirebaseRepository` to handle data fetching, promoting a clean separation between the store and data layers.

15. **lib/stores/pages/account_store.g.dart**
    
    - **Generated Code Updates:**
      - Updated the generated code to reflect the new `shops` and `state` observables and their corresponding getters, setters, and actions. This ensures that the MobX store remains in sync with the manual changes made to the store class.

16. **lib/stores/pages/add_client_store.dart**
    
    - **Imports and Dependencies:**
      - Added imports for `generic_extensions.dart` and `dart:developer` to utilize string manipulation extensions and logging functionalities.
    
    - **Observable Additions:**
      - Introduced the `isAddressEdited` observable to track changes made to a client's address, enabling more precise state management and validation.
    
    - **Method Refactoring and Enhancements:**
      - Refactored the `getClientFromForm` method to handle address updates more effectively, ensuring that location data is accurately updated and reflected in the client model.
      - Implemented the `_updateLocation` action to update the client's address location only when changes have been made, optimizing performance and data accuracy.
    
    - **Validation Improvements:**
      - Replaced the `removeNonNumber` utility method with the `onlyNumbers()` string extension for phone and zip code validations, promoting cleaner and more readable code.
    
    - **Address Handling Enhancements:**
      - Updated address handling logic to manage `location` and `addressString` fields instead of the previously used `geoAddress`, ensuring consistent data representation.
    
    - **Editing Flags Management:**
      - Enhanced the `_checkIsEdited` method and related functionalities to manage both `isEdited` and `isAddressEdited` flags. This provides a more granular control over state changes, ensuring that updates are handled appropriately.
    
    - **Address Mounting Logic:**
      - Modified the `_mountAddress` method to conditionally update the address based on the `isAddressEdited` flag, ensuring that only relevant changes trigger data updates.
    
    - **Action Enhancements:**
      - Implemented additional actions and state checks to manage address edits and ensure data integrity throughout the client creation and editing processes.

17. **lib/stores/pages/add_client_store.g.dart**
    
    - **Generated Code Updates:**
      - Updated the generated code to include the new `isAddressEdited` observable and the `_updateLocation` async action.
      - Refactored the `_checkIsEdited` method to accommodate the new editing flags, ensuring that state changes are accurately tracked and managed.
      - Enhanced the `toString` method to include the `isAddressEdited` flag, providing a more comprehensive string representation of the store's state.

18. **lib/stores/user/user_store.dart**
    
    - **Getter Addition:**
      - Added an `id` getter to retrieve the current user's ID directly from the `currentUser` object. This simplifies access to user identification data throughout the application.

19. **pubspec.yaml**
    
    - **Dependency Adjustments:**
      - Removed an unnecessary blank line to maintain a clean and organized dependencies section.
      - **No other changes** were made in this file during this commit.

**Conclusion:**

This commit brings significant improvements to the application's architecture and functionality:

- **Data Model Enhancements:** By renaming and refactoring fields, the data models now more accurately represent geographical data, improving data integrity and clarity.
  
- **State Management Upgrades:** Introducing new observables and actions in stores like `AccountStore` and `AddClientStore` ensures more responsive and reliable state handling, enhancing the overall user experience.
  
- **User Interface Improvements:** Refactoring UI components to use reusable widgets like `DismissibleClient` and enhancing interaction elements (e.g., buttons for QR code generation and shop loading) result in a cleaner, more intuitive, and maintainable UI codebase.
  
- **Repository Layer Refinements:** Extending repository interfaces and implementing new methods like `getShopByManager` provide more robust data fetching capabilities, ensuring that the application can efficiently manage and display relevant data.
  
- **Lifecycle and Error Handling Enhancements:** Implementing lifecycle observers and comprehensive error handling across controllers and repositories contributes to a more stable and user-friendly application.

Overall, these changes collectively aim to bolster the application's robustness, maintainability, and user-centric design, paving the way for further feature expansions and optimizations.


## 2024/09/23 - version: 0.4.02+20

Update SDK, Firebase, and Scanner Dependencies

This commit upgrades the Flutter SDK, updates Firebase dependencies, replaces the QR code scanner, and removes unnecessary Firebase modules. Below are the detailed changes made across various files:

1. **android/app/build.gradle**
   - Upgraded `compileSdk` from `flutter.compileSdkVersion` to `34`.
   - Changed `jvmTarget` from `JavaVersion.VERSION_1_8` to `"1.8"`.
   - Updated `minSdk` to `21` and `targetSdk` to `34`.

2. **android/app/src/main/AndroidManifest.xml**
   - Modified a comment by adding `FIXME:` to indicate a pending change.

3. **android/build.gradle**
   - Configured `jvmTarget` to `1.8` for all Kotlin modules.
   - Updated `buildscript` dependencies, including `kotlin_version` to `'1.8.10'` and `com.android.tools.build:gradle` to `'8.0.2'`.

4. **android/gradle.properties**
   - Added `dev.steenbakker.mobile_scanner.useUnbundled=true` to enable unbundled mode for `mobile_scanner`.

5. **android/gradle/wrapper/gradle-wrapper.properties**
   - Updated `distributionUrl` from `gradle-7.6.3-all.zip` to `gradle-8.1.1-all.zip`.

6. **docs/Projeto_Delivery_Scrum.md**
   - Renamed from `doc/Projeto_Delivery_Scrum.md` to `docs/Projeto_Delivery_Scrum.md`.

7. **docs/Regras de Segurança do Firebase.md** *(New File)*
   - Added comprehensive documentation on Firebase security rules for the Delivery application.

8. **firestore.rules**
   - Introduced `isBusinessManager()` function.
   - Updated permissions for `clients`, `shops`, and their subcollections.
   - Refactored rules to enhance security and performance.

9. **lib/common/extensions/emu_extensions.dart** *(New File)*
   - Added `DeliveryStatusExtension` to provide display names and colors for delivery statuses.

10. **lib/common/extensions/generic_extensions.dart** *(New File)*
    - Implemented extensions for `num`, `DateTime`, and `String` to handle formatting and data manipulation.

11. **lib/common/models/address.dart**
    - Replaced `latitude` and `longitude` with `GeoPoint? location`.
    - Updated methods to reflect the use of `GeoPoint`.

12. **lib/common/models/client.dart**
    - Added `addressString` and `geoAddress` fields.
    - Updated `toMap` and `fromMap` methods to include new fields.

13. **lib/common/models/delivery.dart** *(New File)*
    - Introduced `DeliveryModel` with comprehensive fields and methods to manage delivery data.

14. **lib/common/models/shop.dart**
    - Made `name` and `description` required fields.
    - Replaced `latitude` and `longitude` with `GeoPoint? location`.
    - Updated methods to handle new fields.

15. **lib/components/widgets/address_card.dart**
    - Changed method call from `address!.addressString()` to `address!.addressRepresentationString()` for better representation.

16. **lib/features/home/home_controller.dart**
    - Commented out `store.setHasPhone(currentUser!.phone != null);` to disable phone check.

17. **lib/features/home/home_page.dart**
    - Added an `Observer` widget to reactively manage UI changes.

18. **lib/features/qrcode_read/qrcode_read_page.dart**
    - Replaced `qr_code_scanner` with `mobile_scanner`.
    - Updated scanning logic to handle QR code detection using `MobileScannerController`.

19. **lib/features/sign_up/sign_up_page.dart**
    - Removed unused reaction disposer and related commented code for cleaner implementation.

20. **lib/repository/firebase_store/abstract_deliveries_repository.dart** *(New File)*
    - Defined an abstract repository interface for managing deliveries.

21. **lib/repository/firebase_store/deliveries_firebase_repository.dart** *(New File)*
    - Implemented `DeliveriesFirebaseRepository` with methods to add, update, delete, and stream delivery data from Firestore.

22. **lib/services/geolocation_service.dart**
    - Refactored to use the `geocoding` package instead of the Google Geocoding API.
    - Updated `getGeoPointFromAddress` to return `GeoPoint?`.

23. **lib/stores/pages/add_client_store.dart**
    - Replaced `removeNonNumber` with `onlyNumbers()` extension.
    - Updated address handling to use `GeoPoint? location`.

24. **lib/stores/pages/add_shop_store.dart**
    - Similar refactoring as `add_client_store.dart` for address handling.
    - Utilized `onlyNumbers()` extension for zip code validation.

25. **lib/stores/pages/common/store_func.dart**
    - Removed the `removeNonNumber` method in favor of using string extensions.

26. **package.json**
    - Updated `firebase-functions` from `^6.0.0` to `^6.0.1`.

27. **package-lock.json**
    - Synced `firebase-functions` version to `6.0.1`.

28. **pubspec.yaml**
    - Updated dependencies:
      - Upgraded `get_it` to `^8.0.0`.
      - Removed `qr_code_scanner` and added `mobile_scanner`, `geocoding`, and `geoflutterfire2`.
      - Updated `firebase_core` to `^2.32.0`, `cloud_firestore` to `^4.17.5`, and other Firebase packages to their latest versions.

These updates enhance the project's compatibility with the latest Flutter and Firebase versions, improve security with refined Firestore rules, and ensure the app uses maintained and optimized packages for QR code scanning and geolocation. The refactoring also promotes cleaner code practices by leveraging Dart extensions and removing deprecated dependencies.


## 2024/09/19 - version: 0.4.01+19

Implemented new features, enhancements, and configuration updates.

1. **android/app/src/main/AndroidManifest.xml**
   - Added `android.permission.CAMERA` permission.

2. **firebase.json**
   - Updated Firebase emulator host to `192.168.0.22` for the following services:
     - Functions
     - Auth
     - Firestore
     - UI
     - Database
     - Storage
     - Remote Config

3. **functions/index.js**
   - Added `managerId` to user claims.
   - Modified `setUserClaims` function to include `managerId` when provided.
   - Updated success message to include `managerId`.

4. **lib/common/models/shop.dart**
   - Added `managerId` and `managerName` fields to `ShopModel`.
   - Updated constructor to initialize `managerId` and `managerName`.
   - Included `managerId` and `managerName` in `toMap`, `fromMap`, `copyWith`, and `toString` methods.

5. **lib/common/models/user.dart**
   - Added `managerId` field to `UserModel`.
   - Updated constructor and `toMap`/`fromMap` methods to handle `managerId`.
   - Added `accountId` getter based on user role.
   - Updated `toString` method to include `managerId`.

6. **lib/features/account_page/account_controller.dart**
   - Introduced `AccountController` class managing `UserStore` and `AccountStore`.
   - Implemented methods to toggle QR code visibility.

7. **lib/features/account_page/account_page.dart**
   - Added `AccountPage` widget with QR code display and toggle functionality.

8. **lib/features/add_shop/add_shop_controller.dart**
   - Added `setManager` method to handle manager selection.

9. **lib/features/add_shop/add_shop_page.dart**
   - Imported `QRCodeReadPage`.
   - Added `_getManager` method to navigate to `QRCodeReadPage` and set manager data.
   - Updated UI to include manager selection interface.

10. **lib/features/home/home_page.dart**
    - Imported `AccountPage`.
    - Added `_accountPage` method to navigate to `AccountPage`.

11. **lib/features/home/widgets/home_drawer.dart**
    - Added `account` callback.
    - Included "Account" ListTile in the navigation drawer.

12. **lib/features/qrcode_read/qrcode_read_page.dart**
    - Introduced `QRCodeReadPage` widget for scanning QR codes.

13. **lib/features/stores/shops_controller.dart**
    - Imported `UserModel`.
    - Added `currentUser` and `accountId` fields.
    - Updated `editShop` method parameters and logic to handle shop data.

14. **lib/features/stores/shops_page.dart**
    - Initialized `ShopsController` in `initState`.

15. **lib/main.dart**
    - Updated Firebase emulator host to `192.168.0.22` for Auth, Firestore, and Functions.

16. **lib/my_material_app.dart**
    - Imported `AccountPage` and `QRCodeReadPage`.
    - Added routes for `AccountPage` and `QRCodeReadPage`.

17. **lib/repository/firebase/firebase_auth_repository.dart**
    - Included `managerId` in user claims.
    - Refactored `adminChecked` logic.
    - Updated methods to handle `managerId`.

18. **lib/repository/firebase_store/shop_firebase_repository.dart**
    - Imported `UserStore`.
    - Updated `streamShopByName` to filter shops based on `accountId`.

19. **lib/stores/pages/account_store.dart**
    - Introduced `AccountStore` with `showQRCode` observable and `toggleShowQRCode` action.

20. **lib/stores/pages/add_shop_store.dart**
    - Added `managerId` and `managerName` observables.
    - Implemented `setManager` action.
    - Updated `getShopFromForm` and `setShopFromShop` methods to handle manager data.

21. **pubspec.yaml**
    - Bumped version to `0.4.01+19`.
    - Added `qr_flutter` and `qr_code_scanner` dependencies.

22. **pubspec.lock**
    - Downgraded `js` package from `0.7.1` to `0.6.7`.
    - Added `qr`, `qr_code_scanner`, and `qr_flutter` packages.

These updates enhance the application's functionality by introducing QR code features, manager handling, and improved Firebase configurations.


## 2024/09/19 - version: 0.4.00+18

Refactor Store Directory Structure, Update Makefile, and Modify User Model

This commit encompasses significant refactoring of the project's directory structure, updates to the Makefile, and modifications to the `UserModel`. Below is a detailed breakdown of the changes:

1. **Makefile Updates (`Makefile`)**
   
   - **Changed Firebase Emulator Export Command:**
     
     - **Before:**
       
       ```makefile
       firebase_emu_make_cache:
           rm -rf ./emulator_data; firebase emulators:export ./emulator_data
       ```
     
     - **After:**
       
       ```makefile
       firebase_emu_make_cache:
           firebase emulators:export ./emulator_data -f
       ```
     
     - **Explanation:**
       
       - Removed the `rm -rf ./emulator_data;` command to prevent forcefully deleting the `emulator_data` directory before exporting.
       - Added the `-f` flag to the `firebase emulators:export` command to force the export, ensuring that existing data is overwritten without manual deletion.

2. **Store Directory Refactoring**
   
   - **Renaming `stores/mobx/` to `stores/pages/`:**
     - **Files Renamed:**
       - `add_client_store.dart` → `pages/add_client_store.dart`
       - `add_client_store.g.dart` → `pages/add_client_store.g.dart`
       - `add_shop_store.dart` → `pages/add_shop_store.dart`
       - `add_shop_store.g.dart` → `pages/add_shop_store.g.dart`
       - `common/store_func.dart` → `pages/common/store_func.dart`
       - `home_store.dart` → `pages/home_store.dart`
       - `home_store.g.dart` → `pages/home_store.g.dart`
       - `personal_data_store.dart` → `pages/personal_data_store.dart`
       - `personal_data_store.g.dart` → `pages/personal_data_store.g.dart`
       - `shops_store.dart` → `pages/shops_store.dart`
       - `shops_store.g.dart` → `pages/shops_store.g.dart`
       - `sign_in_store.dart` → `pages/sign_in_store.dart`
       - `sign_in_store.g.dart` → `pages/sign_in_store.g.dart`
       - `sign_up_store.dart` → `pages/sign_up_store.dart`
       - `sign_up_store.g.dart` → `pages/sign_up_store.g.dart`
     - **Explanation:**
       - The MobX stores were relocated from the `mobx` directory to a new `pages` directory within `stores` to better organize store files based on their associated features or pages.
       - All import statements within the project were updated to reflect the new file paths.

3. **User Model Enhancements (`lib/common/models/user.dart`)**
   
   - **Imported Material Symbols Icons:**
     
     - **Before:**
       
       ```dart
       import 'package:flutter/material.dart';
       ```
     
     - **After:**
       
       ```dart
       import 'package:flutter/material.dart';
       import 'package:material_symbols_icons/material_symbols_icons.dart';
       ```
     
     - **Explanation:**
       
       - Added the `material_symbols_icons` package to utilize a broader range of icons, enhancing the UI's visual appeal.
   
   - **Updated Icon Assignments:**
     
     - **Before:**
       
       ```dart
       case UserRole.admin:
         title = 'Administrador';
         icon = Icons.admin_panel_settings_rounded;
         break;
       // ...
       case UserRole.business:
         title = 'Comerciante';
         icon = Icons.person_rounded;
         break;
       case UserRole.manager:
         title = 'Gerente';
         icon = Icons.manage_accounts_outlined;
         break;
       ```
     
     - **After:**
       
       ```dart
       case UserRole.admin:
         title = 'Administrador';
         icon = Symbols.admin_panel_settings_rounded;
         break;
       // ...
       case UserRole.business:
         title = 'Comerciante';
         icon = Symbols.business;
         break;
       case UserRole.manager:
         title = 'Gerente';
         icon = Symbols.manage_accounts_rounded;
         break;
       default:
         title = 'Clique para entrar';
         icon = Symbols.people_rounded;
         break;
       ```
     
     - **Explanation:**
       
       - Replaced standard `Icons` with `Symbols` from the `material_symbols_icons` package for a more consistent and modern iconography.
       - Added a `default` case to handle scenarios where the user role might not match any predefined roles, providing a fallback title and icon.

4. **Widget Import Path Corrections**
   
   - **Address Card Widget (`lib/components/widgets/address_card.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       ```
     
     - **Explanation:**
       
       - Updated the import path to align with the refactored store directory structure.
   
   - **Add Client Page (`lib/features/add_client/add_cliend_page.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       ```
     
     - **Explanation:**
       
       - Corrected the import path to the relocated `store_func.dart`.
       - **Note:** There's a typo in the filename `add_cliend_page.dart`; it should likely be `add_client_page.dart`. Ensure that the filename is corrected to prevent import issues.
   
   - **Add Client Controller (`lib/features/add_client/add_client_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/add_client_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/add_client_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths to reflect the new store directory structure.
   
   - **Add Shop Controller & Page (`lib/features/add_shop/`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '/stores/mobx/add_shop_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/add_shop_store.dart';
       ```
     
     - **Explanation:**
       
       - Corrected import paths following the store directory refactoring.
   
   - **Home Controller (`lib/features/home/home_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/home_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/home_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated the import path to the relocated `home_store.dart`.
   
   - **Person Data Controller & Page (`lib/features/person_data/`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/personal_data_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/personal_data_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths to align with the new store directory structure.
   
   - **Sign In & Sign Up Controllers (`lib/features/sign_in/`, `lib/features/sign_up/`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/sign_in_store.dart';
       import '../../stores/mobx/sign_up_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/sign_in_store.dart';
       import '../../stores/pages/sign_up_store.dart';
       ```
     
     - **Explanation:**
       
       - Refactored import paths to point to the new locations of the store files.
   
   - **Shops Controller & Page (`lib/features/stores/`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/shops_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/shops_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths following the store directory refactoring.

5. **Store Function Utilities (`lib/stores/pages/common/store_func.dart`)**
   
   - **Created `store_func.dart`:**
     
     - **Content:**
       
       ```dart
       import '../../../common/models/via_cep_address.dart';
       import '../../../repository/viacep/via_cep_repository.dart';
       
       enum PageState { initial, loading, success, error }
       
       enum ZipStatus { initial, loading, success, error }
       
       const addressTypes = [
         'Apartamento',
         'Clínica',
         'Comercial',
         'Escritório',
         'Residencial',
         'Trabalho',
       ];
       
       class StoreFunc {
         StoreFunc._();
       
         static bool itsNotEmail(String? email) {
           final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
           return (email == null || email.isEmpty || !regex.hasMatch(email));
         }
       
         static String removeNonNumber(String? value) {
           return value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
         }
       
         static String? validCpf(String? cpf) {
           if (cpf == null || cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
             return 'CPF inválido';
           }
       
           int digit1 = _calculateDigit(cpf.substring(0, 9), 10);
           int digit2 = _calculateDigit(cpf.substring(0, 10), 11);
       
           bool valid = digit1 == int.parse(cpf[9]) && digit2 == int.parse(cpf[10]);
           if (!valid) {
             return 'CPF inválido';
           }
           return null;
         }
       
         static int _calculateDigit(String cpf, int factor) {
           int total = 0;
           for (int i = 0; i < cpf.length; i++) {
             total += int.parse(cpf[i]) * factor--;
           }
           int rest = total % 11;
           return (rest < 2) ? 0 : 11 - rest;
         }
       
         static Future<(ZipStatus, String?, ViaCepAddressModel?)> fetchAddress(
             String? zipCode) async {
           try {
             final response = await ViaCepRepository.getLocalByCEP(zipCode!);
             if (!response.isSuccess) {
               return (ZipStatus.error, 'CEP inválido', null);
             }
       
             final viaAddress = response.data;
             if (viaAddress == null) {
               return (ZipStatus.error, 'CEP inválido', null);
             }
       
             return (ZipStatus.success, null, viaAddress);
           } catch (err) {
             return (ZipStatus.error, 'erro desconhecido: $err', null);
           }
         }
       }
       ```
     
     - **Explanation:**
       
       - Consolidated utility functions and enums into a centralized `store_func.dart` file within the `pages/common/` directory.
       - Provides helper methods for email validation, CPF validation, number extraction, and address fetching.
       - Defines `PageState` and `ZipStatus` enums for consistent state management across stores.

6. **User Interface Enhancements**
   
   - **Address Card Widget Import Path Correction (`lib/components/widgets/address_card.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       ```
     
     - **Explanation:**
       
       - Updated the import path to the relocated `store_func.dart`.

7. **Controller Import Path Corrections**
   
   - **Add Client Controller (`lib/features/add_client/add_client_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/add_client_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/add_client_store.dart';
       ```
     
     - **Explanation:**
       
       - Corrected import paths to reflect the new store directory structure.
   
   - **Add Shop Controller (`lib/features/add_shop/add_shop_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '/stores/mobx/add_shop_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/add_shop_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths following the store directory refactoring.
   
   - **Home Controller (`lib/features/home/home_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/home_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/home_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated the import path to the relocated `home_store.dart`.
   
   - **Person Data Controller (`lib/features/person_data/person_data_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/personal_data_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/personal_data_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths to align with the new store directory structure.
   
   - **Sign In & Sign Up Controllers (`lib/features/sign_in/sign_in_controller.dart`, `lib/features/sign_up/sign_up_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/sign_in_store.dart';
       import '../../stores/mobx/sign_up_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/sign_in_store.dart';
       import '../../stores/pages/sign_up_store.dart';
       ```
     
     - **Explanation:**
       
       - Refactored import paths to point to the new locations of the store files.
   
   - **Shops Controller (`lib/features/stores/shops_controller.dart`):**
     
     - **Before:**
       
       ```dart
       import '../../stores/mobx/common/store_func.dart';
       import '../../stores/mobx/shops_store.dart';
       ```
     
     - **After:**
       
       ```dart
       import '../../stores/pages/common/store_func.dart';
       import '../../stores/pages/shops_store.dart';
       ```
     
     - **Explanation:**
       
       - Updated import paths following the store directory refactoring.

8. **Store Files Renaming**
   
   - **Renaming Stores from `mobx` to `pages`:**
     - All store files within `lib/stores/mobx/` have been renamed to reside within `lib/stores/pages/`. This includes both the Dart files and their corresponding generated `.g.dart` files.
     - **Example:**
       - `lib/stores/mobx/add_client_store.dart` → `lib/stores/pages/add_client_store.dart`
       - `lib/stores/mobx/add_client_store.g.dart` → `lib/stores/pages/add_client_store.g.dart`
     - **Explanation:**
       - This renaming improves the organizational structure of the project by categorizing stores based on their association with specific pages or features, enhancing maintainability and scalability.

9. **Additional Notes**
   
   - **Typographical Correction:**
     - The filename `add_cliend_page.dart` appears to contain a typo. It should likely be renamed to `add_client_page.dart` to maintain consistency and prevent potential import issues.
   - **Consistency in Enum Usage:**
     - Ensured that enums `PageState` and `ZipStatus` are consistently used across all stores, promoting uniform state management.
   - **Iconography Enhancement:**
     - Transitioned from using standard Flutter `Icons` to `Symbols` from the `material_symbols_icons` package for a more modern and consistent icon set across the application.

These changes collectively enhance the project's structure, improve code maintainability, and ensure consistency in state management and utility functions across different features. The refactoring also paves the way for easier scalability and integration of new features in the future.


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

