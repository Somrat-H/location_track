import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location_track/app_url.dart';
import 'package:location_track/data/background_task.dart';
import 'package:location_track/data/local_storage.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/presentation/employee/auth/auth_landing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthenticationProvider with ChangeNotifier {
  AuthenticationProvider() {
    restoreUser();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;
  bool _isrestoring = false;

  UserModel? get user => _user;
  bool get isRestoring => _isrestoring;

  // Stream to listen to user authentication changes
  // Stream<User?> get authStateChanges => _auth.authStateChanges();

  void restoreUser() async {
    _isrestoring = true;
    final uid = await getCredential();
    if (uid == null || uid == "") {
      notifyListeners();
      _isrestoring = false;
      return;
    }
    await fetchProfile(uid: uid);
  }

  // Method to sign in using email and password
  // Future<bool> signIn(String email, String password, bool isAdmin) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     if (userCredential.user?.uid != null) {
  //       final data =
  //           await fetchProfile(isAdmin: isAdmin, uid: userCredential.user!.uid);
  //       if (data == null) {
  //         false;
  //       }
  //     }

  //     storeCredential(uid: userCredential.user?.uid ?? "");
  //     _user = UserModel(
  //       uid: userCredential.user?.uid ?? "",
  //       name: "Test User",
  //     );
  //     notifyListeners();
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> signIn(
      String email, String password, String isUserOrAdmin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String baseUrl = "${base_url}login"; // Replace with your base URL
    debugPrint(email);
    final data = {
      'username': email,
      'password': password,
      'user_type': isUserOrAdmin,
    };
    print(data);
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        body: {
          'username': email,
          'password': password,
          'user_type': isUserOrAdmin,
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Parse the response if successful
        final Map<String, dynamic> responseData = json.decode(response.body);
        preferences.setString("token", responseData["token"]);
        print('Login successful: $responseData');
        return true;
        // You can handle the login logic here, like saving tokens or navigating to a new screen
      } else {
        // Handle errors based on the status code
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (error) {
      // Handle any exceptions, like network issues
      print('An error occurred: $error');
      return false;
    }
  }

  Future<UserModel?> fetchProfile({bool? isAdmin, required String uid}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final col = await firestore.collection("users").doc(uid).get();
    if (col.data() != null) {
      _user = UserModel.fromJson(col.data()!);
    }

    if (isAdmin == true) {
      if (_user?.role == "admin") {
        return _user;
      }
      _user = null;
    }
    _isrestoring = false;
    notifyListeners();
    return _user;
  }

  // Method to sign out
  // Future<void> signOut() async {
  //   await _auth.signOut();
  //   _user = null;
  //   storeCredential(uid: "");
  //   // BackgroundServiece.stop();
  //   saveLatLong(latLong: const LatLng(0, 0));
  //   notifyListeners();
  // }

  Future<void> signOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    navigateReplaceTo(context: context, widget: AuthLandingScreen());
  }

  // Method to register a new user
  // Future<void> signUp(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //    final data = userCredential.user;
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     rethrow;
  //   }
  // }
}
