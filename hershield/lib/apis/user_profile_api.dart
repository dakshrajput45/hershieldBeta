import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/user_model.dart';

import 'auth/user_auth.dart';

class HSUserApis {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const _userCollectionPath = "userDetails";

  static Future<void> updateUserDetails(
      {required String userId, required HSUser user}) async {
    try {
      await _db.collection(_userCollectionPath).doc(userId).set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      hsLog("Error in HSUserApis: updateUserDetails : $e");
      rethrow;
    }
  }

  static Future<HSUser?> fetchUserById({required String userId}) async {
    try {
      var result = await _db.collection(_userCollectionPath).doc(userId).get();
      if (result.data() != null) {
        return HSUser.fromJson(json: result.data()!);
      }
      return null;
    } catch (e) {
      hsLog("Error in HSUserApis: fetchUserById : $e");
      rethrow;
    }
  }

  static Future<void> updateFcmToken(String token) async {
    try {
      String userId = HSUserAuthSDK.getUser()!.uid;
      await _db.collection(_userCollectionPath).doc(userId).set({
        'fcmtoken': token,
      }, SetOptions(merge: true));
      hsLog("Updated token!!");
    } catch (e) {
      hsLog("Error in HSUserApis: updateFcmToken : $e");
      rethrow;
    }
  }
}
