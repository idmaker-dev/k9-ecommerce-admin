import 'package:cwt_ecommerce_admin_panel/firebase_options.dart';
import 'package:cwt_ecommerce_admin_panel/environment/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
//import 'firebase_options.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  await GetStorage.init();

  // Remove # sign from url
  setPathUrlStrategy();

  // Initialize Supabase (coexists with Firebase during migration)
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Main App Starts here...
  runApp(const App());
}