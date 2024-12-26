import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/check_in_model.dart';
import '../../../models/check_out_model.dart';

class EmployeCheckOut extends StatefulWidget {
  const EmployeCheckOut({super.key});

  @override
  State<EmployeCheckOut> createState() => _EmployeCheckOutState();
}

class _EmployeCheckOutState extends State<EmployeCheckOut> {
  bool isLoading = true;
  List<AttedenceCheckOutModel> attedenceList = [];
  void fetchList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("dailyCheckOut").get();
    if (snapshot.docs.isNotEmpty) {
      List<AttedenceCheckOutModel> userList = snapshot.docs.map((doc) {
        print(doc.data());
        return AttedenceCheckOutModel.fromMap(doc.data());
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
                                  .checkOut!
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
