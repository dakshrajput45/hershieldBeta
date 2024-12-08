// import 'package:backend_shield/helper/log.dart';
// import 'package:permission_handler/permission_handler.dart';

// class UserPermissionHandler {
//   // Function to request foregorund location permissions
//   static Future<bool> requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();

//     // Check if permission is granted
//     if (status.isGranted) {
//       hsLog("Location Permission Granted");
//       return true;
//     } else if (status.isDenied) {
//       hsLog("Location Permission Denied");
//       return false;
//     } else if (status.isPermanentlyDenied) {
//       hsLog("Location Permission Permanently Denied");
//       openAppSettings();
//       return false;
//     }

//     return false;
//   }

//   // Function to request background location permission (if needed)
//   static Future<bool> requestBackgroundPermission() async {
//     PermissionStatus status = await Permission.locationAlways.request();

//     if (status.isGranted) {
//       hsLog("Background Location Permission Granted");
//       return true;
//     } else if (status.isDenied) {
//       hsLog("Background Location Permission Denied");
//       return false;
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//       return false;
//     }

//     return false;
//   }

//   static Future<void> checkAndRequestPermission() async {
//     PermissionStatus status = await Permission.location.status;

//     if (status.isGranted) {
//       // Permission is already granted, proceed as normal
//       return;
//     }

//     if (status.isDenied) {
//       // Request both foreground and background permissions
//       await Permission.location.request();
//       await Permission.locationAlways.request();
//     }

//     status = await Permission.location.status;
//     if (status.isPermanentlyDenied) {
//       checkAndRequestPermission();
//       // Permission is permanently denied, show message
//     }
//   }
// }
