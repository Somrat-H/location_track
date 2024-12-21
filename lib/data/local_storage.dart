import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void storeCredential({required String uid}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("uid", uid);
}

Future<String?> getCredential() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid');
  print(uid);
  return uid;
}

void saveLatLong({required LatLng latLong}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("latitude", latLong.latitude.toString());
  await prefs.setString("longitude", latLong.longitude.toString());
}

Future<LatLng?> getLastLatLong() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final latitude = prefs.getString("latitude");
  final longitude = prefs.getString("longitude");
  if (latitude != null && longitude != null) {
    return LatLng(double.parse(latitude), double.parse(longitude));
  }
  return null;
}
