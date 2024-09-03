import 'package:get_it/get_it.dart';

import '/common/settings/app_settings.dart';
import 'common/storage/local_storage_service.dart';
import 'stores/user/user_store.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerSingleton<LocalStorageService>(LocalStorageService());

  locator.registerSingleton<AppSettings>(AppSettings());

  locator.registerLazySingleton<UserStore>(() => UserStore());
}

void disposeDependencies() {}
