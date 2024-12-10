import '../helper/log.dart';
import 'package:location/location.dart';


Future<LocationData?> getForegroundLocation() async {
  Location location = Location();

  try {
    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Request to enable location services
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        hsLog("Location service is disabled. Cannot fetch location.");
        return null; // Exit if location service can't be enabled
      }
    }

    // Check if the location permission is granted
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      // Request location permission if it's not granted
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        hsLog("Location permission denied. Cannot fetch location.");
        return null; // Exit if permission is denied
      }
    }

    // Fetch and return the location data
    LocationData locationData = await location.getLocation();
    hsLog(
        "Foreground Location: ${locationData.latitude}, ${locationData.longitude}");
    return locationData;
  } catch (e) {
    hsLog("Error fetching foreground location: $e");
    return null;
  }
}
