import 'dart:convert';
import 'package:hershield/helper/api_paths.dart';
import 'package:hershield/helper/log.dart';
import 'package:http/http.dart' as http;

class LocationApi {
  Future<void> updateUserLocation({
    required String lat,
    required String long,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiPaths.updateLocationPath),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'lat': lat,
          'long': long,
          'uid': userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        hsLog('User location updated successfully');
      } else {
        hsLog(
            'Failed to update location: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      hsLog('Error updating user location data: $error');
    }
  }
}
