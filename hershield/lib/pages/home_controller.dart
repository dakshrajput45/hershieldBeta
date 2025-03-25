import 'package:flutter/material.dart';
import 'package:hershield/apis/location_api.dart';
import 'package:hershield/apis/user_profile_api.dart';
import 'package:hershield/models/user_model.dart';

class HSProfileController extends ChangeNotifier {
  static HSUser? _profile;
  static HSUser? getProfile() => _profile;
  final LocationApi locationApi = LocationApi();

  static Future<HSUser?> fetchUser({required String userId}) async {
    try {
      _profile = await HSUserApis.fetchUserById(userId: userId);
      return _profile;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLocationController({
    required String lat,
    required String long,
    required String userId,
  }) async {
    try {
      await locationApi.updateUserLocation(
          lat: lat, long: long, userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}
