import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location_track/presentation/admin/admin_home_view.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/presentation/employee/auth/auth_landing.dart';
import 'package:location_track/presentation/employee/auth/auth_mode.dart';
import 'package:location_track/presentation/employee/auth/login_view.dart';
import 'package:location_track/presentation/employee/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay and navigate to the next screen (e.g., HomePage) after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      AuthModel authModel = AuthModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? authData = preferences.getString('auth_data');

      authModel = AuthModel.fromJson(jsonDecode(authData!));

      if (authData != null) {
        if (authModel.data!.userType == 1) {
          navigateReplaceTo(context: context, widget: const HomeView());
        } else if (authModel.data!.userType == 2) {
          navigateReplaceTo(context: context, widget: const AdminHomeView());
        }
      } else {
        navigateTo(context: context, widget: const AuthLandingScreen());
      }
      // Replace '/home' with your home route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image
            Image.asset(
              'assets/logo.png', // Replace with your image path in assets
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20), // Add spacing between image and text
            // Display the text
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
