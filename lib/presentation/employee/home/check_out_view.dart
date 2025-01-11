import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as lok;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../app_url.dart';
import 'package:image/image.dart' as img;
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
      // Pick an image using the camera
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // Save the original image to a known directory
        final directory = await getApplicationDocumentsDirectory();
        final savedImagePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(image.path).copy(savedImagePath);

        // Mock data for location and temperature
        String temperature = "25°C"; // Replace with API call if needed

        // Add overlays to the image
        final updatedImage = await _addOverlayToImage(
          savedImagePath,
          "Mirpur",
          temperature,
        );

        // Convert image to JPEG (if needed for server upload)
        final jpegImage = await _convertToJpeg(updatedImage);

        // Update state with the new image
        setState(() {
          _image = XFile(jpegImage.path); // Ensure using JPEG for upload
        });

        // Debug: Print the path of the final image
        print("Final image saved at: ${jpegImage.path}");
      }
    } catch (e) {
      _showSnackBar("Error capturing image: $e");
    }
  }

  Future<File> _addOverlayToImage(
    String imagePath,
    String address,
    String temperature,
  ) async {
    final originalImage = await _loadImage(File(imagePath));
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final size = Size(
        originalImage.width.toDouble(), originalImage.height.toDouble() + 200);

    // Draw the original image
    canvas.drawImage(originalImage, Offset.zero, paint);

    // Draw a white container at the bottom
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(0, originalImage.height.toDouble(), size.width, 200),
      paint,
    );

    // Add overlay text
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    // Initialize location object
    lok.Location location = lok.Location();

    // Check and request location permissions
    bool _serviceEnabled;
    dynamic _permissionGranted;
    lok.LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception("Location service is disabled.");
      }
    }

    // Check location permissions
    _permissionGranted = (await location.hasPermission());
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted =
          (await location.requestPermission());
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception("Location permission denied.");
      }
    }

    // Get current location
    _locationData = await location.getLocation();

    double latitude = _locationData.latitude ?? 0.0;
    double longitude = _locationData.longitude ?? 0.0;

    final overlayText = [
      "Lat: $latitude",
      "Lon: $longitude",
      "Address: $address",
      "Temp: $temperature",
    ];

    double offsetY =
        originalImage.height.toDouble() + 20.0; // Start at container top

    for (String text in overlayText) {
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout(minWidth: 0, maxWidth: size.width - 20);
      textPainter.paint(canvas, Offset(10, offsetY));
      offsetY += textPainter.height + 5; // Move down for next line
    }

    final picture = recorder.endRecording();
    final newImage =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final overlayFile = File(imagePath.replaceFirst('.jpg', '_overlay.png'));
      await overlayFile.writeAsBytes(byteData.buffer.asUint8List());
      return overlayFile;
    } else {
      throw Exception("Failed to add overlay to image");
    }
  }

  Future<ui.Image> _loadImage(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<File> _convertToJpeg(File pngFile) async {
    final bytes = await pngFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception("Failed to decode PNG image");

    final jpegBytes =
        img.encodeJpg(image, quality: 85); // Adjust quality if needed
    final jpegFilePath = pngFile.path.replaceAll('.png', '.jpg');
    final jpegFile = File(jpegFilePath);
    await jpegFile.writeAsBytes(jpegBytes);

    return jpegFile;
  }

  Future<void> _getCurrentLocation() async {
    try {
     lok.Location location = lok.Location();

    // Check and request location permissions
    bool _serviceEnabled;
    dynamic _permissionGranted;
    lok.LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception("Location service is disabled.");
      }
    }

    // Check location permissions
    _permissionGranted = (await location.hasPermission());
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted =
          (await location.requestPermission());
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception("Location permission denied.");
      }
    }

    // Get current location
    _locationData = await location.getLocation();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble());

      setState(() {
        _currentPosition = LatLng(_locationData.latitude!.toDouble(),_locationData.longitude!.toDouble());
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

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> checkOut() async {
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
        "image": _image!.path,
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
        title: const Text("Check Out"),
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
                  await checkOut();
                  final service = FlutterBackgroundService();
                  service.invoke("stopService");
                  setState(() {});
                },
          child: isSubmitting
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text("Confirm Check Out"),
        ),
      ),
    );
  }
}

  Future<void> uploadLocationData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    // Initialize location
     lok.Location location = lok.Location();

    // Check and request location permissions
    bool _serviceEnabled;
    dynamic _permissionGranted;
    lok.LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception("Location service is disabled.");
      }
    }

    // Check location permissions
    _permissionGranted = (await location.hasPermission());
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted =
          (await location.requestPermission());
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception("Location permission denied.");
      }
    }

    // Get current location
    _locationData = await location.getLocation();

    // Prepare request headers
    var headers = {
      'Authorization': 'Bearer ${preferences.getString("token")}',
    };

    // Prepare request body
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://tracking.dengrweb.com/api/v1/location_track'),
    );

    request.fields.addAll({
      'location': 'Dhaka, Bangladesh', // Replace with a dynamic location if needed
      'longitude': _locationData.longitude.toString(),
      'latitude': _locationData.latitude.toString(),
      'attendance_time': DateTime.now().toString(), // Current timestamp
    });

    request.headers.addAll(headers);

    // Send the request
    http.StreamedResponse response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("Data uploaded successfully: $responseBody");
    } else {
      print("Failed to upload data: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error occurred while uploading location data: $e");
  }
  }
  
  


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        await uploadLocationData();

        // debugPrint("Lat: ${position.latitude}, Lon: ${position.longitude}");

        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at",
        );
      } 
    }

    
  });
}

