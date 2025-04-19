import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/services/api.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token; // later assign a value
  late int userId;
  late String name;
  late ApiService apiService;

  AuthProvider() {
    init(); //institiate the init function
  }

  Future<void> init() async {
    //dart function to initialize the token
    token =
        await SharedPrefService.getToken(); //get the token form shared preferences(local storage)chceck from laravel token

    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners(); // its package(provider) function to notify the listeners

    userId = await SharedPrefService.getUserId();
    name = await SharedPrefService.getName();
  }

  Future<void> login(String email, String password) async {
    await apiService.login(email, password);
    token = apiService.token;
    userId = apiService.userId;
    name = apiService.name;
    SharedPrefService.setToken(token);
    SharedPrefService.setUserId(userId);
    SharedPrefService.setName(name);
    isAuthenticated =
        true; // set the authentication status to true after successful login
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPrefService.setToken(''); //
    SharedPrefService.setUserId(0);
    SharedPrefService.setName('');

    isAuthenticated = false;
    notifyListeners();
  }
}
