import '../helper/log.dart';
import 'package:permission_handler/permission_handler.dart';

// Function to request background location permission (if needed)
Future<bool> requestBackgroundPermission() async {
  PermissionStatus status = await Permission.locationAlways.request();

  if (status.isGranted) {
    hsLog("Background Location Permission Granted");
    return true;
  } else if (status.isDenied) {
    hsLog("Background Location Permission Denied");
    return false;
  } else if (status.isPermanentlyDenied) {
    hsLog("Open Settings");
    return false;
  }

  return false;
}

Future<bool> isLocationAlwaysGranted() async {
  // Check if background location permission is granted
  PermissionStatus status = await Permission.locationAlways.status;

  if (status.isGranted) {
    hsLog("Background Location Permission Granted");
    return true;
  } else {
    hsLog("Permission Not Determined");
    false;
    //isLocationAlwaysGranted();
  }
  return false;
}
