// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
