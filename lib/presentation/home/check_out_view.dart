import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../data/auth_provider.dart';
import '../../data/operations.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // A variable to store the image
  XFile? _image;
  String _location = 'Getting location...';
  bool isLoading = true;
  final ImagePicker _picker = ImagePicker();
  // late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(23.8041, 90.4152);

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<void> _getCurrentLocation() async {
    // Check for permission status
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      setState(() {
        _location = 'Permission denied!';
      });
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high)

        // You can choose the accuracy
        );

    setState(() {
      _location =
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
      //

      isLoading = false;
    });
  }

  @override
  void initState() {
    _takePicture();
    _getCurrentLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _image == null
              ? const Text('No image selected.')
              : Image.file(File(_image!.path)),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    buildingsEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: _currentPosition, zoom: 18.0),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          )
        ],
      )),
      bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
                onPressed: () async {
                  if (isLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Looking for your current location')),
                    );
                    return;
                  } else {
                    final feedback = await checkOut(
                        employeeId: authProvider.user?.uid ?? "",
                        latLong: [
                          _currentPosition.latitude,
                          _currentPosition.latitude
                        ]);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(feedback)),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Confirm Check out")),
          )),
    );
  }
}
