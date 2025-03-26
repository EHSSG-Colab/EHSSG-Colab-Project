import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPrefService {
  // Save API token
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  // Retrieve API token
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Retrieved token: $token');
    return token;
  }

  // Save user ID
  Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    print('User ID saved: $userId');
  }

  // Retrieve user ID
  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    print('Retrieved user ID: $userId');
    return userId;
  }

  // Save user name
  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    print('User name saved: $name');
  }

  // Retrieve user name
  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? '';
    print('Retrieved user name: $name');
    return name;
  }

  // Save all login data (token, userId, userName)
  Future<void> saveLoginData({
    required String token,
    required int userId,
    required String userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
    print(
      'Login data saved: {token: $token, userId: $userId, userName: $userName}',
    );
  }

  // Save email
  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    print('Email saved: $email');
  }

  // Retrieve email
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    print('Retrieved email: $email');
    return email;
  }

  // Retrieve all login data
  Future<Map<String, dynamic>> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final loginData = {
      'token': prefs.getString('token') ?? '',
      'userId': prefs.getInt('userId') ?? 0,
      'userName': prefs.getString('userName') ?? '',
      'email': prefs.getString('email') ?? '',
    };
    print('Retrieved login data: $loginData');
    return loginData;
  }

  // Save profile details
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

    // Generate and save userId if it doesn't exist
    if (prefs.getString('userId') == null) {
      final userId = const Uuid().v4();
      await prefs.setString('userId', userId);
      print('Generated and saved user ID: $userId');
    }

    print(
      'Profile details saved: {userName: $userName, userTownship: $userTownship, userVillage: $userVillage, villageNotFound: $villageNotFound, userOtherVillage: $userOtherVillage}',
    );
  }

  // Retrieve profile details
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfo = {
      'userId': prefs.getString('userId') ?? '',
      'userName': prefs.getString('userName') ?? '',
      'userTownship': prefs.getString('userTownship') ?? '',
      'userVillage': prefs.getString('userVillage') ?? '',
      'villageNotFound': prefs.getBool('villageNotFound') ?? false,
      'userOtherVillage': prefs.getString('userOtherVillage') ?? '',
    };
    print('Retrieved profile details: $userInfo');
    return userInfo;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data cleared.');
  }
}
