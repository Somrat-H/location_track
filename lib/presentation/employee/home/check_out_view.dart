import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../app_url.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  XFile? _image;
  bool isLoading = true;
  bool isSubmitting = false; // Indicates if check-in is in progress
  String? _locationName;
  final ImagePicker _picker = ImagePicker();
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(23.8041, 90.4152);

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      _showSnackBar('Error taking picture');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permission is required');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Validate coordinates
      if (position.latitude == null || position.longitude == null) {
        _showSnackBar('Failed to retrieve valid location coordinates');
        return;
      }

      // Reverse geocoding
      List<Placemark> placemarks = [];
      try {
        placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        print(placemarks);
      } catch (geocodingError) {
        print(geocodingError);
        _showSnackBar('Reverse geocoding failed: $geocodingError');
      }

      // Update state
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationName = placemarks.isNotEmpty
            ? '${placemarks[0].name},${placemarks[0].street}, ${placemarks[0].subLocality},, ${placemarks[0].locality}'
            : 'Unknown Location';
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition,
            infoWindow: InfoWindow(title: _locationName),
          ),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Failed to get location: $e');
    }
  }

  Future<void> checkIn() async {
    if (_image == null) {
      _showSnackBar('Please capture an image first');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      _showSnackBar('Authentication token not found');
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    try {
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://tracking.dengrweb.com/api/v1/attendance"),
      )
        ..fields.addAll({
          'latitude': _currentPosition.latitude.toString(),
          'longitude': _currentPosition.longitude.toString(),
          'location': _locationName ?? 'Unknown Location',
          'attendance_type': "1",
        })
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path))
        ..headers.addAll(headers);
      final data = {
        'latitude': _currentPosition.latitude.toString(),
        'longitude': _currentPosition.longitude.toString(),
        'location': _locationName ?? 'Unknown Location',
        'attendance_type': "1",
      };
      print(data);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        _showSnackBar('Check-out successful');
        Navigator.pop(context); // Navigate back to the home page
      } else {
        _showSnackBar('Check-out failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('Error during check-out: $e');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _image == null
                  ? GestureDetector(
                      onTap: _takePicture,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_enhance,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 10),
                          const Text('Tap to capture an image'),
                        ],
                      ),
                    )
                  : Image.file(File(_image!.path)),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _currentPosition, zoom: 18.0),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  await checkIn();
                },
          child: isSubmitting
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text("Confirm Check In"),
        ),
      ),
    );
  }
}
