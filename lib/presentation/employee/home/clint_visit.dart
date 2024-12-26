import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/auth_provider.dart';
import '../../../data/operations.dart';

class ClintVisitView extends StatefulWidget {
  const ClintVisitView({super.key});

  @override
  State<ClintVisitView> createState() => _ClintVisitViewState();
}

class _ClintVisitViewState extends State<ClintVisitView> {
  // A variable to store the image
  XFile? _image;
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
        _getCurrentLocation();
      });
      // return;
    }
    // if (permission != LocationPermission.always) {
    //   await Geolocator.requestPermission();
    //   setState(() {});
    //   return;
    // }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high)

        // You can choose the accuracy
        );

    setState(() {
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

  final TextEditingController noteController = TextEditingController();
  final TextEditingController clintNameController = TextEditingController();
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
            SizedBox(
              height: 200,
              child: _image == null
                  ? const Center(
                      child: Text('No image selected.'),
                    )
                  : Image.file(File(_image!.path)),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Google Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
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
            ),
            const SizedBox(height: 20),
            const Text(
              "Meeting Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: clintNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: "Clint Name",
                    labelText: "Clint Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                maxLines: 5,
                minLines: 3,
                controller: noteController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Meeting Note",
                    labelText: "Meeting Note"),
              ),
            ),
          ],
        ),
      ),
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
                    final feedback = await clintVisit(
                      employeeId: authProvider.user?.uid ?? "",
                      employeName: authProvider.user?.name ?? "",
                      clintName: "list name",
                      note: "lorem",
                      latLong: [
                        _currentPosition.latitude,
                        _currentPosition.latitude
                      ],
                      image: File(_image!.path),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(feedback)),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Confirm Check in")),
          )),
    );
  }
}
