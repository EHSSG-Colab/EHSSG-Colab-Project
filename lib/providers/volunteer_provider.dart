import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';

class VolunteerProvider extends ChangeNotifier {
  // initial profile complete status
  bool isVolunteerProfileComplete = false;

  Map<String, dynamic> volunteerInfo = {};
  bool _isInitialized = false;

  VolunteerProvider() {
    init();
  }

  Future<void> init() async {
    if (_isInitialized) return;
    // get user info from shared preference helper
    volunteerInfo = await SharedPrefService.getvolunteerInfo();
    _updateVolunteerProfileCompleteStatus();
    _isInitialized = true;
    notifyListeners();
  }

  void _updateVolunteerProfileCompleteStatus() {
    isVolunteerProfileComplete =
        volunteerInfo['volunteerName']?.isNotEmpty == true &&
        volunteerInfo['volunteeerTownship']?.isNotEmpty == true &&
        volunteerInfo['volunteerVillage']?.isNotEmpty == true;
  }

  Future<void> updateVolunteerInfo({
    required String volunteerName,
    required String volunteerTownship,
    required String volunteerVillage,
  }) async {
    await SharedPrefService.saveVolunteerInfo(
      volunteerName: volunteerName,
      volunteerTownship: volunteerTownship,
      volunteerVillage: volunteerVillage,
    );
    volunteerInfo = await SharedPrefService.getvolunteerInfo();
    _updateVolunteerProfileCompleteStatus();
    notifyListeners();
  }

  bool get isInitialized => _isInitialized;
}
