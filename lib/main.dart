import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/my_material_app.dart';
import 'common/settings/app_settings.dart';
import 'locator.dart';
import 'services/firebase_service.dart';
import 'services/remote_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  // Se estiver no modo de desenvolvimento, conecte ao emulador do Firestore
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    log('Use firebase emulator...');
  }

  setupDependencies();
  await locator<AppSettings>().init();
  await locator<RemoteConfig>().init();

  runApp(const MyMaterialApp());
}
