import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_track/data/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<bool> signIn(String email, String password, bool isAdmin) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.uid != null) {
        final data =
            await fetchProfile(isAdmin: isAdmin, uid: userCredential.user!.uid);
        if (data == null) {
          false;
        }
      }

      storeCredential(uid: userCredential.user?.uid ?? "");
      _user = UserModel(
        uid: userCredential.user?.uid ?? "",
        name: "Test User",
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
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
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    storeCredential(uid: "");
    notifyListeners();
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
