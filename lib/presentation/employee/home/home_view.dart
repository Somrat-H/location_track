import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/env.dart';
import 'package:location_track/presentation/employee/home/check_out_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/auth_provider.dart';
import '../auth/auth_landing.dart';
import '../auth/auth_mode.dart';
import 'check_in_view.dart';
import 'clint_visit.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthModel? _authModel;

  void _checkPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }

    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> _loadAuthData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authData = preferences.getString('auth_data');

    if (authData != null) {
      setState(() {
        _authModel = AuthModel.fromJson(jsonDecode(authData));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadAuthData();
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              authProvider.signOut(context);
              navigateReplaceTo(
                  context: context, widget: const AuthLandingScreen());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            // User Info Container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://tracking.dengrweb.com/${_authModel!.data!.image}"),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _authModel?.data!.name ?? "Loading...",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          _authModel?.data!.designation ??
                              "Designation not available",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _authModel?.data!.phone ?? "Phone not available",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          _authModel?.data!.email ?? "Email not available",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Check-In Button
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      navigateTo(
                          context: context, widget: const CheckInScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/checkIn.png",
                            height: 30,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            "Check In",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                // Check-Out Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(
                          context: context, widget: const CheckOutView());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE9901),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/checkOut.png",
                            height: 30,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            "Check Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Second Row: Clint Visit Button
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 137, 118),
                    ),
                    onPressed: () {
                      navigateTo(
                          context: context, widget: const ClintVisitView());
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
