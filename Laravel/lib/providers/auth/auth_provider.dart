import 'package:flutter/foundation.dart';
import 'package:malaria_report_mobile/services/api.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;
  late int userId;
  late String name;
  late ApiService apiService;

  AuthProvider() {
    init(); //instantiating the ApiService class
  }

  Future<void> init() async {
    token =
        await SharedPrefService()
            .getToken(); //shared preferences to get the token
    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners(); //use notifyListeners() to notify the listeners of the change in the state

    userId = await SharedPrefService().getUserId();
    name = await SharedPrefService().getName();
  }

  Future<void> login(String email, String password) async {
    await apiService.login(email, password);
    token = apiService.token;
    userId = apiService.userId;
    name = apiService.name;
    SharedPrefService().setToken(token);
    SharedPrefService().setUserId(userId);
    SharedPrefService().setName(name);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPrefService().setToken('');
    SharedPrefService().setUserId(0);
    SharedPrefService().setName('');

    isAuthenticated = false;
    notifyListeners();
  }
}
