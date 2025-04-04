import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  // initial profile complete status
  bool isProfileComplete = false;

  Map<String, dynamic> userInfo = {};
  bool _isInitialized = false;

  ProfileProvider() {
    init();
  }

  Future<void> init() async {
    if (_isInitialized) return;

    // get user info from shared preference helper
    // Used a try catch approach here
    try {
      userInfo = await SharedPrefService.getUserInfo();
      _updateProfileCompleteStatus();
    } catch (e) {
      print('Error initializing profile provider: $e');
      // Error handling by setting default values to prevent messy info saved to shared preferences
      userInfo = {
        'userId': '',
        'userName': '',
        'userTownship': '',
        'userVillage': '',
        'villageNotFound': false,
        'userOtherVillage': '',
      };
      isProfileComplete = false;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  void _updateProfileCompleteStatus() {
    // check if userName is provided by the user
    bool hasUserName = userInfo['userName']?.isNotEmpty == true;

    // check if userTownship is provided by the user
    bool hasTownship = userInfo['userTownship']?.isNotEmpty == true;

    // check if userVillage is provided, either regular village or other village
    bool hasVillage = false; // false initially
    // if villageNotFound is checked, need to check other village
    if (userInfo['villageNotFound'] == true) {
      hasVillage = userInfo['userOtherVillage']?.isNotEmpty == true;
    } else {
      hasVillage = userInfo['userVillage']?.isNotEmpty == true;
    }

    // profile will be set as completed if all required fields are true
    isProfileComplete = hasUserName && hasTownship && hasVillage;
  }

  Future<void> updateUserInfo({
    required String userName,
    required String userTownship,
    required String userVillage,
    required bool villageNotFound,
    required String userOtherVillage,
  }) async {
    // Added a try catch here
    try {
      await SharedPrefService.saveUserInfo(
        userName: userName,
        userTownship: userTownship,
        userVillage: userVillage,
        villageNotFound: villageNotFound,
        userOtherVillage: userOtherVillage,
      );
      userInfo = await SharedPrefService.getUserInfo();
      _updateProfileCompleteStatus();
      notifyListeners();
    } catch (e) {
      print('Error updating user info: $e');
      rethrow;
    }
  }

  bool get isInitialized => _isInitialized;
}
