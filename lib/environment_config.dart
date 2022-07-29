import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/config_reader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// - this contains the developement environment type `dev`,`prod` and `staging`
/// if we add in the future.
/// - Additionaly this will have the endpoints which will be used in `dev` and
///  `prod` ex. http://localhost:3000/myfunction
class EnvironmentConfig {
  /// - used by dart define
  static const envName = 'ENV';

  /// - production enviroment
  static const String prod = "PROD";

  /// - develomment enviroment
  static const String dev = "DEV";
}

/// HACK: this can used to run logics depending on different environment
/// - awaiting this in `prod` wont affect the performance of the app
Future<void> setUpMain(String env) async {
  if (env == EnvironmentConfig.dev) {
    log('dev');
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final ConfigReader configReader = ConfigReader();
    await configReader.initializeConfigReader();
    await FirebaseAuth.instance.useAuthEmulator(
      configReader.getIp,
      configReader.authenticationPort,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      configReader.getIp,
      configReader.firestorePort,
    );

    await FirebaseStorage.instance.useStorageEmulator(
      configReader.getIp,
      configReader.firebaseStoragePort,
    );
  }
}
