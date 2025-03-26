import 'dart:convert';

import 'package:malaria_report_mobile/providers/api_response.dart';
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

  static const String _apiUserKey = 'api_user_info'; // Key for storing API info

  // Save API User Info in SharedPreferences
  static Future<void> storeUserApiInfo(ApiResponse apiResponse) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(apiResponse.toJson()); // Convert to JSON string
    await prefs.setString(_apiUserKey, jsonData);
  }

  // Retrieve API User Info from SharedPreferences
  static Future<ApiResponse?> getUserApiInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(_apiUserKey);
    
    if (jsonData == null) return null; // Return null if no data is found

    Map<String, dynamic> userMap = jsonDecode(jsonData);
    return ApiResponse.fromJson(userMap); // Convert JSON to ApiResponse object
  }

  // Clear user API info on logout
  static Future<void> clearUserApiInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiUserKey);
  }

  // Individual Getters (Retrieve specific user details)
  static Future<String> getApiUserId() async {
    ApiResponse? apiResponse = await getUserApiInfo();
    return apiResponse?.apiUserId ?? '';
  }

  static Future<String> getApiUsername() async {
    ApiResponse? apiResponse = await getUserApiInfo();
    return apiResponse?.apiUsername ?? '';
  }

  static Future<String> getApiEmail() async {
    ApiResponse? apiResponse = await getUserApiInfo();
    return apiResponse?.apiEmail ?? '';
  }

  static Future<String> getApiTownship() async {
    ApiResponse? apiResponse = await getUserApiInfo();
    return apiResponse?.apiTownship ?? '';
  }

  static Future<String> getApiToken() async {
    ApiResponse? apiResponse = await getUserApiInfo();
    return apiResponse?.token ?? '';
  }

  // Individual Setters
  // static Future<void> setApiUserId(String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('api_user_id', userId);
  // }

  // static Future<void> setApiUsername(String username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('api_username', username);
  // }

  // static Future<void> setApiEmail(String email) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('api_email', email);
  // }

  // static Future<void> setApiTownship(String township) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('api_township', township);
  // }

  // // Individual Getters
  // static Future<String> getApiUserId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_user_id') ?? '';
  // }

  // static Future<String> getApiUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_username') ?? '';
  // }

  // static Future<String> getApiEmail() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_email') ?? '';
  // }

  // static Future<String> getApiTownship() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_township') ?? '';
  // }

  


  // static Future<void> storeUserApiInfo( {
  //     required String apiUserId,
  //     required String apiUsername,
  //     required String apiEmail,
  //     required String apitownship,
  // }) async{
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('api_user_id', apiUserId);
    
  //   await prefs.setString('api_username', apiUsername);
  //   await prefs.setString('api_email', apiEmail);
  //   await prefs.setString('api_township',apitownship);
  // }

  // //get user api information
  // static Future<Map<String,String?>> getUserApiInfo() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return{
  //     'userId' : prefs.getString('api_user_id'),
  //     'username' : prefs.getString('api_username'),
  //     'email' : prefs.getString('api_email'),
  //     'township' : prefs.getString('api_township'),
  //   };
  // }
}
