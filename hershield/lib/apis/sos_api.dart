import 'dart:convert';
import 'package:hershield/helper/api_paths.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/user_model.dart';
import 'package:http/http.dart' as http;

class SosApi {
  Future<List<HSUser>?> findNearByUser({required String userId}) async {
    try {
      hsLog("${ApiPaths.findNearByUserPath}?uid=$userId");
      final response = await http
          .get(Uri.parse("${ApiPaths.findNearByUserPath}?uid=$userId"));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['nearbyUsers'];
        hsLog(responseData.toString());

        hsLog("User near by you: ${responseData.length}");
        if (responseData.isEmpty) return [];

        List<HSUser> users = responseData
            .map((userJson) => HSUser.fromJson(json: userJson))
            .toList();

        return users;
      }

      hsLog("Error: Received status code ${response.statusCode}");
      return null;
    } catch (error) {
      hsLog('Error finding nearby user: $error');
    }
    return null;
  }
}
