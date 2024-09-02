import 'package:flutter/material.dart';

import '/my_material_app.dart';
import 'locator.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  setupDependencies();

  runApp(const MyMaterialApp());
}
