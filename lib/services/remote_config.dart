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
