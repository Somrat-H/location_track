import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location_track/data/local_storage.dart';
import 'package:location_track/firebase_options.dart';
import 'package:location_track/presentation/home/home_view.dart';

import 'data/auth_provider.dart';
import 'data/background_task.dart';
import 'presentation/auth/auth_landing.dart';
import 'package:provider/provider.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: MaterialApp(
        title: appName,
        showSemanticsDebugger: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: const AuthGurd(),
      ),
    );
  }
}

class AuthGurd extends StatelessWidget {
  const AuthGurd({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authGurd = context.watch();

    if (authGurd.isRestoring) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (authGurd.user != null) {
      return HomeView();
    } else {
      return AuthLandingScreen();
    }
  }
}
