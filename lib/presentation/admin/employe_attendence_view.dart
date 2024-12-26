import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/attendence_model.dart';

class EmployeAttendence extends StatefulWidget {
  const EmployeAttendence({super.key});

  @override
  State<EmployeAttendence> createState() => _EmployeAttendenceState();
}

class _EmployeAttendenceState extends State<EmployeAttendence> {
  bool isLoading = true;
  List<AttedenceModel> attedenceList = [];
  void fetchList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("attendance").get();
    if (snapshot.docs.isNotEmpty) {
      List<AttedenceModel> userList = snapshot.docs.map((doc) {
        print(doc.data());
        return AttedenceModel.fromMap(doc.data());
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
                          subtitle: Text(attedenceList[index]
                              .dailyUpdate
                              .first
                              .name
                              .toString()),
                        )),
              ),
      ),
    );
  }
}
