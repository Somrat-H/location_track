import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../models/check_in_model.dart';
import '../models/clint_model.dart';
import '../models/user_model.dart';
import 'local_storage.dart';

DateFormat formatter = DateFormat('hh:mm a');
DateFormat hourly = DateFormat('yMd-hh:mm:ss a');

// Add attendance (check-in and check-out time)
Future<String> clintVisit({
  required String employeeId,
  required String clintName,
  required String employeName,
  required String note,
  required List<double> latLong,
  required File image,
}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final date = DateTime.now();
  try {
    final imageUrl = await _uploadImage(image);
    if (imageUrl == null) {
      return "Unable to upload the image";
    }

    final col = firestore.collection('clintVisit').doc();

    // Add employee attendance data under the date
    await col.set({
      "id": col.id,
      "latLong": latLong,
      "image": imageUrl,
      "employeeId": employeeId,
      "note": "note",
      "time": "formatter.format(date)",
    }, SetOptions(merge: true));

    return "Successfully added clint visit";
  } catch (e) {
    return "Unable to add clint visit";
  }
}

Future<bool> checkIn({
  required String employeeId,
  required String name,
  required List<double> latLong,
  required File image,
}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    // final imageUrl = await _uploadImage(image);
    // if (imageUrl == null) {
    //   return false;
    // }

    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = firestore
        .collection('dailyCheckIn')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      "title": "${date.day}-${date.month}-${date.year}",
      "dailyUpdate": [
        {
          "employeeId": employeeId,
          "name": "name",
          "checkIn": {
            "time": formatter.format(date),
            "latLong": latLong,
            "image": "imageUrl",
          },
        }
      ]
    }, SetOptions(merge: true));

    return true; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
  }
}

// Add attendance (check-in and check-out time)
Future<bool> checkOut(
    {required String employeeId,
    required List<double> latLong,
    required File image}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    // final imageUrl = await _uploadImage(image);
    // if (imageUrl == null) {
    //   return false;
    // }
    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = firestore
        .collection('dailyCheckOut')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      "title": "${date.day}-${date.month}-${date.year}",
      "dailyUpdate": [
        {
          "employeeId": employeeId,
          "name": "name",
          "checkOut": {
            "time": formatter.format(date),
            "latLong": latLong,
            "image": "imageUrl",
          },
        }
      ]
    }, SetOptions(merge: true));

    return true; // Merge if the document already exists
  } catch (e) {
    print(e);
    return false;
  }
}

// Method to upload the image to Firebase Storage
Future<String?> _uploadImage(File image) async {
  try {
    // Reference to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${DateTime.now().millisecondsSinceEpoch}.png');

    // Upload the image
    await storageRef.putFile(image);

    // Get the download URL of the uploaded image
    return await storageRef.getDownloadURL();
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

// Add attendance (check-in and check-out time)
Future<String> continusUpdate({
  required String employeeId,
  required List<double> latLong,
}) async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyABt7nPK_5KISobwc6Fp_BMEt9fd_I7PME',
    appId: '1:845446719321:android:1f8790f9cf47653ead8e48',
    messagingSenderId: '845446719321',
    projectId: 'chat-bine',
    storageBucket: 'chat-bine.appspot.com',
  ));

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc =
        firestore.collection('currentLocation').doc(employeeId);

    // Add employee attendance data under the date
    await attendanceDoc.set({
      "lastUpdate": hourly.format(date),
      "employeeId": employeeId,
      "latLong": latLong,
    }, SetOptions(merge: true));

    return "Successfully added your attendence"; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
  }
}

Future<void> trackLocation() async {
  final uid = await getCredential();
  if (uid == null) {
    return;
  }
  final latlong = await getLastLatLong();
  Position currentPosition = await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high));

  if (latlong?.latitude != currentPosition.latitude ||
      latlong?.longitude != currentPosition.longitude) {
    saveLatLong(
        latLong: LatLng(currentPosition.latitude, currentPosition.longitude));
    continusUpdate(
        employeeId: uid,
        latLong: [currentPosition.latitude, currentPosition.longitude]);
  }
}

Future<List<UserModel>> listEmployee() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection("users").get();
  if (snapshot.docs.isNotEmpty) {
    List<UserModel> userList = snapshot.docs.map((doc) {
      return UserModel.fromJson(doc.data());
    }).toList();
    return userList;
  }

  return [];
}

// Future<List<AttedenceCheckInModel>> employeeCheckInList() async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final snapshot = await firestore.collection("dailyCheckIn").get();
//   if (snapshot.docs.isNotEmpty) {
//     List<AttedenceCheckInModel> userList = snapshot.docs.map((doc) {
//       return AttedenceCheckInModel.fromMap(doc.data());
//     }).toList();
//     return userList;
//   }
//   return [];
// }

// Future<List<AttedenceCheckInModel>> employeeCheckOutList() async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final snapshot = await firestore.collection("dailyCheckOut").get();
//   if (snapshot.docs.isNotEmpty) {
//     List<AttedenceCheckInModel> userList = snapshot.docs.map((doc) {
//       return AttedenceCheckInModel.fromMap(doc.data());
//     }).toList();
//     return userList;
//   }
//   return [];
// }

Future<List<ClintModel>> clintVisitList() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection("clintVisit").get();
  if (snapshot.docs.isNotEmpty) {
    List<ClintModel> userList = snapshot.docs.map((doc) {
      return ClintModel.fromJson(doc.data());
    }).toList();
    return userList;
  }

  return [];
}
