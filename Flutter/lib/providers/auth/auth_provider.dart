import 'package:flutter/foundation.dart';
import 'package:malaria_report_mobile/services/api.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  // late keyword from token is removed to prevent late initilization error as the user may not have a token during first time login
  String token = '';
  int userId = 0;
  String name = '';
  late ApiService apiService;

  AuthProvider() {
    init(); //instantiating the ApiService class
  }

  Future<void> init() async {
    token =
        await SharedPrefService()
            .getToken(); //shared preferences to get the token

    // initialize API service with token (even if empty)
    apiService = ApiService(token: token);

    // check if token exists and set authentication status
    if (token.isNotEmpty) {
      isAuthenticated = true;
      userId = await SharedPrefService().getUserId();
      name = await SharedPrefService().getName();
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // attempt to login
    await apiService.login(email, password); // if this line is successful, it will proceed
    
    // log in is successful at this point. The web api will be replying information
    // this information is assigned here
    token = apiService.token;
    userId = apiService.userId;
    name = apiService.name;

    // save these values to shared preferences
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
