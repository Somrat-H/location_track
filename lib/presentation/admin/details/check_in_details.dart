import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/check_in_model.dart';

class CheckInDetails extends StatelessWidget {
  const CheckInDetails({super.key, required this.dailyCheckInList});
  final List<DailyCheckInUpdate> dailyCheckInList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            dailyCheckInList.length,
            (index) => ListTile(
              title: Text(dailyCheckInList[index].name.toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id : ${dailyCheckInList[index].employeeId.toString()}"),
                  Text(
                      "Time : ${dailyCheckInList[index].checkIn!.time.toString()}"),
                  // Text("Latitude : ${dailyCheckInList[index].checkIn?.latlong?[0]??""}"),
                  // Text("Longtitude : ${dailyCheckInList[index].checkIn!.latlong![1].toString()}"),
                ],
              ),
              leading: CachedNetworkImage(
                width: 100,
                  imageUrl: dailyCheckInList[index].checkIn?.imageUrl ?? ""),
            ),
          ),
        ),
      ),
    );
  }
}
