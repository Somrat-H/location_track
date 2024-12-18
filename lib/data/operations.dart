import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateFormat formatter = DateFormat('hh:mm a');
// Future <String> checkin({required String uid,required List<double> latlong}) async{
//    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final db= await _firestore.collection('attendence').doc(data);

//    await _firestore.collection('attendence').doc(uid).set({
//           'name': name,
//           'email': email,
//           'uid': user.uid,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         return "";
// }

// Add attendance (check-in and check-out time)
Future<String> addAttendance(
{required  String employeeId, required List<double>latLong}
) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = _firestore
        .collection('attendance')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      employeeId: {
        "checkIn": formatter.format(date),
        "latLong": latLong
      }
    }, SetOptions(merge: true));

    return "Successfully added your attendence"; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
  }
}
// Add attendance (check-in and check-out time)
Future<String> checkOut(
{required  String employeeId, required List<double>latLong}
) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final date = DateTime.now();
  try {
    // Get reference to the attendance collection, using the date as the document ID
    DocumentReference attendanceDoc = _firestore
        .collection('attendance')
        .doc("${date.day}-${date.month}-${date.year}");

    // Add employee attendance data under the date
    await attendanceDoc.set({
      employeeId: {
        "checkOut": formatter.format(date),
        "latLong": latLong
      }
    }, SetOptions(merge: true));

    return "Successfully added your attendence"; // Merge if the document already exists
  } catch (e) {
    throw Exception('Failed to add attendance: $e');
  }
}
