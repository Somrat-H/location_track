import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

DateFormat formatter = DateFormat('hh:mm a');

// Add attendance (check-in and check-out time)
Future<String> addAttendance(
    {required String employeeId,
    required List<double> latLong,
    required File image}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    final imageUrl = await _uploadImage(image);
    if (imageUrl == null) {
      return "Unable to upload the image";
    }

    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = firestore
        .collection('attendance')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      employeeId: {
        "checkIn": {
          "time": formatter.format(date),
          "latLong": latLong,
          "image": imageUrl,
        },
      }
    }, SetOptions(merge: true));

    return "Successfully added your attendence"; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
  }
}

// Add attendance (check-in and check-out time)
Future<String> checkOut(
    {required String employeeId,
    required List<double> latLong,
    required File image}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    final imageUrl = await _uploadImage(image);
    if (imageUrl == null) {
      return "Unable to upload the image";
    }
    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = firestore
        .collection('attendance')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      employeeId: {
        "checkOut": {
          "time": formatter.format(date),
          "latLong": latLong,
          "image": imageUrl,
        }
      }
    }, SetOptions(merge: true));

    return "Successfully added your attendence"; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
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
