import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_track/presentation/common/nav.dart';
import 'package:location_track/presentation/employee/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../data/auth_provider.dart';
import 'package:path_provider/path_provider.dart';

class ClintVisitView extends StatefulWidget {
  const ClintVisitView({super.key});

  @override
  State<ClintVisitView> createState() => _ClintVisitViewState();
}

class _ClintVisitViewState extends State<ClintVisitView> {
  XFile? _image;
  bool isLoading = true;
  bool isSubmitting = false;
  final ImagePicker _picker = ImagePicker();
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(23.8041, 90.4152);
  String? _locationName;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController clintNameController = TextEditingController();

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final savedImagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy(savedImagePath);

      setState(() {
        _image = XFile(savedImage.path); // Use the saved path
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permission is required');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

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

  Future<void> clientVisit() async {
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
        Uri.parse("http://tracking.dengrweb.com/api/v1/client_visit"),
      )
        ..fields.addAll({
          'latitude': _currentPosition.latitude.toString(),
          'longitude': _currentPosition.longitude.toString(),
          'location': _locationName ?? 'Unknown Location',
        })
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path))
        ..headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        _showSnackBar('Clint Visit successful');

        // Navigate back to the home page
        if (context.mounted) {
          navigateReplaceTo(context: context, widget: HomeView());
        }
      } else {
        _showSnackBar('Clint Visit failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('Error during Clint Visit: $e');
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
    final AuthenticationProvider authProvider = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Visit"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: _image == null
                  ? Center(
                      child: TextButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture Image'),
                      ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Client Name",
                  labelText: "Client Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Meeting Note",
                  labelText: "Meeting Note",
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isSubmitting || isLoading
              ? null
              : () async {
                  await clientVisit();
                },
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Confirm Visit"),
        ),
      ),
    );
  }
}
