import 'package:get_it/get_it.dart';

import '/services/remote_config.dart';
import '/common/settings/app_settings.dart';
import 'repository/firebase_store/abstract_client_repository.dart';
import 'repository/firebase_store/client_firebase_repository.dart';
import 'services/local_storage_service.dart';
import 'stores/user/user_store.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerSingleton<LocalStorageService>(LocalStorageService());

  locator.registerSingleton<AppSettings>(AppSettings());

  locator.registerLazySingleton<UserStore>(() => UserStore());

  locator.registerSingleton<RemoteConfig>(RemoteConfig());

  locator.registerLazySingleton<AbstractClientRepository>(
      () => ClientFirebaseRepository());
}

void disposeDependencies() {
  locator<UserStore>().dispose();
}
