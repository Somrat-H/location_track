import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location_track/data/operations.dart';

// Initialize the background service
void initBackgroundService() {
  final mainServiece = FlutterBackgroundService();
  mainServiece.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: _onStart,
      autoStart: true,
      autoStartOnBoot: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
        autoStart: true,
        onBackground: _onIsolateBackground,
        onForeground: _onStart),
  );
}

@pragma('vm:entry-point')
Future<bool> _onIsolateBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
Future<void> _onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
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

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
    await  trackLocation();
    }

    // service.invoke("update");
  });
}

class BackgroundServiece {
  static final servie = FlutterBackgroundService();
  static void startForgound() async {
    if (await servie.isRunning()) {
      servie.invoke("setAsForeground");
    } else {
      servie.startService();
      servie.invoke("setAsForeground");
    }
  }

  static void startBackground() async {
    if (await servie.isRunning()) {
      servie.invoke("setAsBackground");
    } else {
      final done = await servie.startService();
      servie.invoke("setAsBackground");
      print("background engine status $done");
    }
  }

  static void stop() {
    servie.invoke("stopService");
  }
}
