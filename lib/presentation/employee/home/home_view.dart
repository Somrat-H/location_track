import 'package:flutter/material.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/env.dart';
import 'package:location_track/presentation/employee/home/check_out_view.dart';
import 'package:provider/provider.dart';

import '../../../data/auth_provider.dart';
import '../auth/auth_landing.dart';
import 'check_in_view.dart';
import 'clint_visit.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'dart:io';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // void handlePermission() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission != LocationPermission.denied && context.mounted) {
  //     // await showLocationPermission(context);
  //     await Geolocator.requestPermission();
  //   }
  //   Geolocator.requestPermission().asStream();
  //   // if (permission == LocationPermission.always) {

  //   // }
  // }
  void _checkPermissions() async {
    // Requesting Camera permission
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      // Request permission if not granted
      PermissionStatus cameraNewStatus = await Permission.camera.request();
      if (cameraNewStatus.isGranted) {
        // print("Camera permission granted");
      } else {
        await Permission.camera.request();
        // print("Camera permission denied");
      }
    } else {
      // print("Camera permission already granted");
    }

    // Requesting Location permission
    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      // Request location permission if not granted
      PermissionStatus locationNewStatus = await Permission.location.request();
      if (locationNewStatus.isGranted) {
        // print("Location permission granted");
      } else {
        // print("Location permission denied");
      }
    } else {
      // print("Location permission already granted");
    }
  }

  @override
  void initState() {
    _checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context.watch();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.withOpacity(0.1),
        title: const Text(appName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                authProvider.signOut();
                navigateReplaceTo(
                    context: context, widget: const AuthLandingScreen());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          // crossAxisAlignment: WrapCrossAlignment.center,
          // spacing: 20,
          // runSpacing: 20,
          // alignment: WrapAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 0,
            ),
            FilledButton.icon(
                onPressed: () async {
                  navigateTo(context: context, widget: const CheckInScreen());
                },
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/checkIn.png",
                    height: 40,
                  ),
                ),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Check In"),
                )),
            const SizedBox(
              height: 15,
            ),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFE9901)),
                onPressed: () {
                  navigateTo(context: context, widget: const CheckOutScreen());
                },
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/checkOut.png",
                    height: 40,
                  ),
                ),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Check Out"),
                )),
            const SizedBox(
              height: 20,
            ),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 95, 137, 118),
                ),
                onPressed: () {
                  navigateTo(context: context, widget: const ClintVisitView());
                },
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/clintVisit.png",
                    height: 40,
                  ),
                ),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Clint Visit"),
                )),
          ],
        ),
      ),
    );
  }
}
