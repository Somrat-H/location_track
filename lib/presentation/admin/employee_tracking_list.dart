import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_track/models/employee_model.dart';
import 'package:location_track/presentation/admin/employee_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  EmployeeListModel employeeModel = EmployeeListModel();

  /// Fetches the employee list from the API
  Future<EmployeeListModel> fetchEmployeeList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final headers = {
      'Authorization': 'Bearer ${preferences.getString("admin_token")}',
    };

    final request = http.Request(
      'GET',
      Uri.parse('http://tracking.dengrweb.com/api/v1/employee/all'),
    );

    request.headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return EmployeeListModel.fromJson(jsonDecode(responseBody));
      } else {
        print("Error: ${response.reasonPhrase}");
        return EmployeeListModel();
      }
    } catch (e) {
      print("Exception: $e");
      return EmployeeListModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
        centerTitle: true,
      ),
      body: FutureBuilder<EmployeeListModel>(
        future: fetchEmployeeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null ||
              snapshot.data!.data!.data!.isEmpty) {
            return const Center(child: Text("No employees found."));
          } else {
            final employees = snapshot.data!.data!.data;
            return ListView.builder(
              itemCount: employees!.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://tracking.dengrweb.com${employee.image}" ??
                                  ""),
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                employee.designation ?? "No designation",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                employee.phone ?? "No phone",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EmployeeModel {
  List<EmployeeData> data;

  EmployeeModel({this.data = const []});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => EmployeeData.fromJson(item))
          .toList(),
    );
  }
}

class EmployeeData {
  String? name;
  String? designation;
  String? phone;
  String? image;

  EmployeeData({this.name, this.designation, this.phone, this.image});

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      name: json['name'],
      designation: json['designation'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
