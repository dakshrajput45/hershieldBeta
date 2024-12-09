import '../services/user_permission.dart';
import 'package:flutter/material.dart';

void showLocationPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Location Permission Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please allow location access **all the time** so we can assist you in case of an emergency.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Deny',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              showSnackbar(context, 
                'We need your location to provide assistance in emergencies.');
            },
          ),
          ElevatedButton(
            child: const Text('Allow'),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              requestBackgroundPermission(); 
            },
          ),
        ],
      );
    },
  );
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    ),
  );
}


