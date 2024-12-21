import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location_track/models/user_model.dart';

import '../../data/operations.dart';

class MyEmployeListView extends StatefulWidget {
  const MyEmployeListView({super.key});

  @override
  State<MyEmployeListView> createState() => _MyEmployeListViewState();
}

class _MyEmployeListViewState extends State<MyEmployeListView> {
  bool isLoading = true;
  List<UserModel> employeList = [];
  void fetchList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("users").get();
    if (snapshot.docs.isNotEmpty) {
      List<UserModel> userList = snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
      employeList = userList;
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
      appBar: AppBar(
        title: Text("Employee List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: List.generate(
                  employeList.length,
                  (index) => employeList[index].role == "admin"
                      ? SizedBox(
                          height: 0,
                        )
                      : ListTile(
                          title: Text(employeList[index].name),
                          subtitle: Text(employeList[index].department ?? "NA"),
                          leading: CachedNetworkImage(
                            imageUrl: employeList[index].imageUrl ?? "",
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    const CircularProgressIndicator(),
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
