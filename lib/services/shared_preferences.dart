import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Save API token
  // Switched to static for consistency
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Retrieve API token
  // Made this static for consistency
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  // Save user ID
  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  // Retrieve user ID
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    return userId;
  }

  // Save user name
  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  // Retrieve user name
  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? '';
    return name;
  }

  // Save all login data (token, userId, userName)
  static Future<void> saveLoginData({
    required String token,
    required int userId,
    required String userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
  }

  // Save email
  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  // Retrieve email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    return email;
  }

  // Retrieve all login data
  static Future<Map<String, dynamic>> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final loginData = {
      'token': prefs.getString('token') ?? '',
      'userId': prefs.getInt('userId') ?? 0,
      'userName': prefs.getString('userName') ?? '',
      'email': prefs.getString('email') ?? '',
    };
    return loginData;
  }

  // Save profile details
  // THIS METHOD HANDLES PROFILE DATA, NOT LOGIN DETAILS
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
  }

  // Retrieve profile details
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // get userId as int and convert to string
    final userId = prefs.getInt('userId');
    final userIdString = userId != null ? userId.toString() : '';

    final userInfo = {
      'userId': userIdString,
      'userName': prefs.getString('userName') ?? '',
      'userTownship': prefs.getString('userTownship') ?? '',
      'userVillage': prefs.getString('userVillage') ?? '',
      'villageNotFound': prefs.getBool('villageNotFound') ?? false,
      'userOtherVillage': prefs.getString('userOtherVillage') ?? '',
    };
    return userInfo;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
