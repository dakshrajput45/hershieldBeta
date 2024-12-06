import 'package:backend_shield/apis/user_profile_api.dart';
import 'package:backend_shield/helper/log.dart';
import 'package:backend_shield/models/user_model.dart';

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
