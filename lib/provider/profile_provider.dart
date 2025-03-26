import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/services/shared_preferences.dart';

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
    userInfo = await SharedPrefService.getUserInfo();
    _updateProfileCompleteStatus();
    _isInitialized = true;
    notifyListeners();
  }

  void _updateProfileCompleteStatus() {
    isProfileComplete =
        userInfo['userName']?.isNotEmpty == true &&
        userInfo['userTownship']?.isNotEmpty == true &&
        (userInfo['userVillage']?.isNotEmpty == true ||
            userInfo['userOtherVillage']?.isNotEmpty == true);
  }

  Future<void> updateUserInfo({
    required String userName,
    required String userTownship,
    required String userVillage,
    required bool villageNotFound,
    required String userOtherVillage,
  }) async {
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
  }

  bool get isInitialized => _isInitialized;
}
