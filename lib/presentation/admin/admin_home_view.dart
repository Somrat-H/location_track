import 'package:flutter/material.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:provider/provider.dart';

import '../../data/auth_provider.dart';
import '../employee/auth/auth_landing.dart';
import 'employe_attendence_view.dart';
import 'employe_list.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            FilledButton(
                onPressed: () {
                  navigateTo(
                      context: context, widget: const MyEmployeListView());
                },
                child: Text("My Employees")),
            FilledButton(
                onPressed: () {
                  navigateTo(context: context, widget:const EmployeAttendence());
                },
                child: Text("Employees Attendences")),
          ],
        ),
      ),
    );
  }
}
