import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  late final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  String get googleApi => _remoteConfig.getString('google_api_key');

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
