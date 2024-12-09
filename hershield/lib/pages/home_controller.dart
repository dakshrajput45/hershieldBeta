
import 'package:flutter/material.dart';
import 'package:hershield/apis/user_profile_api.dart';
import 'package:hershield/models/user_model.dart';

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
