import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPrefService {
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? '';
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'userName': prefs.getString('userName'),
      'userTownship': prefs.getString('userTownship'),
      'userVillage': prefs.getString('userVillage'),
      'villageNotFound': prefs.getBool('villageNotFound') ?? false,
      'userOtherVillage': prefs.getString('userOtherVillage'),
    };
  }

  // save user info
  static Future<void> saveUserInfo({
    required String userName,
    required String userTownship,
    required String userVillage,
    required bool villageNotFound,
    required String userOtherVillage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userTownship', userTownship);
    await prefs.setString('userVillage', userVillage);
    await prefs.setBool('villageNotFound', villageNotFound);
    await prefs.setString('userOtherVillage', userOtherVillage);

    // Check if userId exists, if not, generate and save it
    if (prefs.getString('userId') == null) {
      final userId = const Uuid().v4();
      await prefs.setString('userId', userId);
    }
  }
}
