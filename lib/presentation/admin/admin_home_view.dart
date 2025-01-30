import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location_track/presentation/admin/admin-auth_model.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/env.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/auth_provider.dart';
import '../employee/auth/auth_landing.dart';
import '../employee/auth/auth_mode.dart';
import 'employee_tracking_list.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  AdminAuthModel? _authModel;

  void _checkPermissions() async {
    await [
      Permission.camera,
      Permission.location,
    ].request();
  }

  Future<void> _loadAuthData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authData = preferences.getString('auth_data');
    if (authData != null) {
      setState(() {
        _authModel = AdminAuthModel.fromJson(jsonDecode(authData));
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Container
            _authModel != null
                ? Container(
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
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(
                        //       "https://tracking.dengrweb.com/${_authModel!.data!.image}"),
                        // ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   _authModel?.data!.name ?? "Loading...",
                              //   style: const TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18,
                              //   ),
                              // ),
                              // Text(
                              //   _authModel?.data!.designation ??
                              //       "Designation not available",
                              //   style: TextStyle(
                              //     color: Colors.grey[700],
                              //     fontSize: 14,
                              //   ),
                              // ),
                              const SizedBox(height: 8.0),
                              // Text(
                              //   _authModel?.data!.phone ??
                              //       "Phone not available",
                              //   style: TextStyle(
                              //     color: Colors.grey[600],
                              //     fontSize: 14,
                              //   ),
                              // ),
                              Text(
                                _authModel?.data!.email ??
                                    "Email not available",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 30.0),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Employee Tracking navigation
                      navigateTo(context: context, widget: EmployeeListPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Employee Tracking",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Employee Attendance navigation
                      // navigateTo(context: context, widget: const EmployeeAttendanceView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Employee Attendance",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
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
