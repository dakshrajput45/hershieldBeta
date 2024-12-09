
import 'package:hershield/apis/user_profile_api.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/user_model.dart';

class HSUserController {
  static Future<void> updateUser(
      {required HSUser user, required String userId}) async {
    try {
      hsLog("Updated User Called");
      await HSUserApis.updateUserDetails(userId: userId, user: user);
    } catch (e) {
      rethrow;
    }
  }

}
