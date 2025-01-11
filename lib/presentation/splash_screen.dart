import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location_track/presentation/admin/admin_home_view.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/presentation/employee/auth/auth_landing.dart';
import 'package:location_track/presentation/employee/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employee/auth/auth_mode.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Initializes the app and decides the navigation path
  Future<void> _initializeApp() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? authData = preferences.getString('auth_data');

      if (authData != null) {
        final authModel = AuthModel.fromJson(jsonDecode(authData));

        if (authModel.data != null) {
          if (authModel.data!.userType == 1) {
            navigateReplaceTo(context: context, widget: const HomeView());
          } else if (authModel.data!.userType == 2) {
            navigateReplaceTo(context: context, widget: const AdminHomeView());
          } else {
            // Default to AuthLandingScreen for unknown user types
            navigateReplaceTo(context: context, widget: const AuthLandingScreen());
          }
        } else {
          navigateReplaceTo(context: context, widget: const AuthLandingScreen());
        }
      } else {
        navigateReplaceTo(context: context, widget: const AuthLandingScreen());
      }
    } catch (e) {
      debugPrint("Error initializing app: $e");
      // Navigate to the authentication landing page on error
      navigateReplaceTo(context: context, widget: const AuthLandingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    // Simulate a delay before navigating to the next screen
    Future.delayed(const Duration(seconds: 3), _initializeApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/logo.png', // Replace with your image path in assets
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20), // Spacing between image and text
            // Welcome Text
            const Text(
              'Welcome to VIA OFFICE', // Replace with your app name or text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
