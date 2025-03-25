import 'package:hershield/helper/log.dart';

class SosApi {
  Future<void> findNearByUser() async {
    try {} catch (error) {
      hsLog('Error finding near by user: $error');
    }
  }
}
