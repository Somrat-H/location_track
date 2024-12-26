import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/check_in_model.dart';

class EmployeCurrentLocation extends StatefulWidget {
  const EmployeCurrentLocation({super.key});

  @override
  State<EmployeCurrentLocation> createState() => _EmployeCurrentLocationState();
}

class _EmployeCurrentLocationState extends State<EmployeCurrentLocation> {
  bool isLoading = true;
  List<AttedenceCheckInModel> attedenceList = [];
  void fetchList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("currentLocation").get();
    if (snapshot.docs.isNotEmpty) {
      List<AttedenceCheckInModel> userList = snapshot.docs.map((doc) {
        print(doc.data());
        return AttedenceCheckInModel.fromMap(doc.data());
      }).toList();
      attedenceList = userList;
    }

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Text("Loading..")
            : Column(
                children: List.generate(
                    attedenceList.length,
                    (index) => ListTile(
                          title: Text(attedenceList[index].title.toString()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(attedenceList[index]
                                  .dailyUpdate[index]
                                  .name
                                  .toString()),
                              Text(attedenceList[index]
                                  .dailyUpdate[index]
                                  .checkIn!
                                  .time
                                  .toString()),
                            ],
                          ),
                        )),
              ),
      ),
    );
  }
}
