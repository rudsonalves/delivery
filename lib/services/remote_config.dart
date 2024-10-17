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

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteConfig {
  late final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  Future<String> get googleApi async {
    if (kDebugMode) {
      await dotenv.load(fileName: '.env');
      return dotenv.env['GOOGLE_API_KEY'] ?? '';
    } else {
      return _remoteConfig.getString('google_api_key');
    }
  }

  Future<void> init() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval:
            const Duration(seconds: 1), // allow to searrch immediately
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }
}
