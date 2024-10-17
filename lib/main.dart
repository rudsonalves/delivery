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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
    await FirebaseAuth.instance.useAuthEmulator('192.168.0.22', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('192.168.0.22', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('192.168.0.22', 5001);
    log('Using firebase emulator...');
  }

  setupDependencies();
  await locator<AppSettings>().init();
  await locator<RemoteConfig>().init();

  runApp(const MyMaterialApp());
}
