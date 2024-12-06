import 'package:backend_shield/apis/user_profile_api.dart';
import 'package:backend_shield/models/user_model.dart';
import 'package:flutter/material.dart';

class HSProfileController extends ChangeNotifier {
  static HSUser? _profile;
  static HSUser? getProfile() => _profile;

  static Future<HSUser?> fetchUser({required String userId}) async {
    try {
      _profile = await HSUserApis.fetchUserById(userId: userId);
      return _profile;
    } catch (e) {
      rethrow;
    }
  }
}
