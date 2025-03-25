import 'package:hershield/helper/api_paths.dart';
import 'package:hershield/helper/log.dart';
import 'package:http/http.dart' as http;

class SosApi {
  Future<void> findNearByUser({required String userId}) async {
    try {
      final response =
          http.get(Uri.parse("${ApiPaths.findNearByUserPath}?uid=$userId)"));
    } catch (error) {
      hsLog('Error finding near by user: $error');
    }
  }
}
