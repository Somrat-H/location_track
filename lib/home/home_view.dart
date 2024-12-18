import 'package:flutter/material.dart';
import 'package:location_track/common/nav.dart';
import 'package:location_track/env.dart';
import 'package:image_picker/image_picker.dart';

import 'check_in_view.dart';
// import 'dart:io';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.withOpacity(0.1),
        title: const Text(appName),
        centerTitle: true,
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
                onPressed: () {
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
                onPressed: () {},
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
              height: 15,
            ),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 95, 137, 118),
                ),
                onPressed: () {},
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
