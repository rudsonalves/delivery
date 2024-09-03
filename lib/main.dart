import 'package:flutter/material.dart';

import '/my_material_app.dart';
import 'common/settings/app_settings.dart';
import 'locator.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  setupDependencies();
  await locator<AppSettings>().init();

  runApp(const MyMaterialApp());
}
