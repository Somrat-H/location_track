import 'package:flutter/material.dart';

// Reusable dialog widget that returns a boolean value
Future<bool> showLocationPermission(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please allow location permission to continus'),
            content: const Text('Please allow location permission as "Alwoys" so that we can track your location'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Allow'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Denie'),
              ),
            ],
          );
        },
      ) ??
      false;
}
// Reusable dialog widget that returns a boolean value
Future<bool> showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please allow location permission to continus'),
            content: const Text('Please allow location permission as "Alwoys" so that we can track your location'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Allow'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Denie'),
              ),
            ],
          );
        },
      ) ??
      false;
}
