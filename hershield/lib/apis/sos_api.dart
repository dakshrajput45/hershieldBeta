import 'dart:convert';
import 'package:hershield/helper/api_paths.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/safe_places_model.dart';
import 'package:http/http.dart' as http;

class SosApi {
  Future<int> findNearByUser({required String userId}) async {
    try {
      hsLog("${ApiPaths.findNearByUserPath}?uid=$userId");
      final response = await http
          .get(Uri.parse("${ApiPaths.findNearByUserPath}?uid=$userId"));

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body)['nearbyUsers'];
        hsLog(responseData.toString());

        hsLog("User near by you: ${responseData.length}");
        if (responseData.isEmpty) return 0;

        return responseData.length;
      }

      hsLog("Error: Received status code ${response.statusCode}");
      return 0;
    } catch (error) {
      hsLog('Error finding nearby user: $error');
    }
    return 0;
  }

  Future<SafePlacesResult> findNearBySafePlaces(
      {required String userId}) async {
    try {
      final response = await http
          .get(Uri.parse("${ApiPaths.findNearBySafePlacesPath}?uid=$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> safePlacesData = data['safePlaces'];

        hsLog("Safe Places near you: ${safePlacesData.length}");

        if (safePlacesData.isEmpty) {
          return SafePlacesResult(places: [], directionsUrl: null);
        }

        List<HSSafePlace> safePlaces = safePlacesData
            .map((placeJson) => HSSafePlace.fromJson(placeJson))
            .toList();

        String? directionsUrl = data['directionsUrl'];

        return SafePlacesResult(
            places: safePlaces, directionsUrl: directionsUrl);
      }

      hsLog("Error: Received status code ${response.statusCode}");
      return SafePlacesResult(places: null, directionsUrl: null);
    } catch (error) {
      hsLog('Error finding nearby safe places: $error');
      return SafePlacesResult(places: null, directionsUrl: null);
    }
  }
}
