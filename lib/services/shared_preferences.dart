import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Save API token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  // Retrieve API token
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Retrieved token: $token');
    return token;
  }

  // Save user ID
  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    print('User ID saved: $userId');
  }

  // Retrieve user ID
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    print('Retrieved user ID: $userId');
    return userId;
  }

  // Save user name
  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    print('User name saved: $name');
  }

  // Retrieve user name
  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? '';
    print('Retrieved user name: $name');
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
    print('Email saved: $email');
  }

  // Retrieve email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    print('Retrieved email: $email');
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
    print('Retrieved login data: $loginData');
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

  // Save volunteer details
  static Future<void> saveVolunteerInfo({
    required String volunteerName,
    required String volunteerTownship,
    required String volunteerVillage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('volunteerName', volunteerName);
    await prefs.setString('volunteerTownship', volunteerTownship);
    await prefs.setString('volunteerVillage', volunteerVillage);

    print(
      'Volunteer details saved: {userName: $volunteerName, userTownship: $volunteerTownship, userVillage: $volunteerVillage,}',
    );
  }

  // Retrieve volunteer details
  static Future<Map<String, dynamic>> getvolunteerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final volunteerInfo = {
      'volunteerId': prefs.getString('volunteerId') ?? '',
      'volunteerName': prefs.getString('volunteerName') ?? '',
      'volunteerTownship': prefs.getString('volunteerTownship') ?? '',
      'volunteerVillage': prefs.getString('volunteerVillage') ?? '',
    };
    print('Retrieved volunteer details: $volunteerInfo');
    return volunteerInfo;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
