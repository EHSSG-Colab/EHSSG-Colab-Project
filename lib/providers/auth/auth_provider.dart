import 'package:flutter/foundation.dart';
import 'package:malaria_report_mobile/services/api.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';
import 'package:malaria_report_mobile/providers/api_response.dart';

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
    // final response =
    await apiService.login(email, password); // if this line is successful, it will proceed
    
    // log in is successful at this point. The web api will be replying information
    // this information is assigned here
    token = apiService.token;
    userId = apiService.userId;
    name = apiService.name;
  
    // save these values to shared preferences
    await SharedPrefService().setToken(token);
    await SharedPrefService().setUserId(userId);
    await SharedPrefService().setName(name);
    
    

    isAuthenticated = true;
    notifyListeners();

    // return ApiResponse.fromJson(response);
  }

  
  Future<void> logOut() async {
    await SharedPrefService().setToken('');
    await SharedPrefService().setUserId(0);
    await SharedPrefService().setName('');

    isAuthenticated = false;
    notifyListeners();
  }
}
class AuthProviderApi extends ChangeNotifier {
  bool isAuthenticated = false;
  String token = '';
  int userId = 0;
  String name = '';
  late ApiService apiService;

  AuthProviderApi() {
    init();
  }

  Future<void> init() async {
    token = await SharedPrefService.getApiToken(); // Retrieve token
    apiService = ApiService(token: token);

    if (token.isNotEmpty) {
      isAuthenticated = true;
      userId = int.parse(await SharedPrefService.getApiUserId());
      name = await SharedPrefService.getApiUsername();
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final response = await apiService.login(email, password); 
    
    // Convert response into ApiResponse model
    ApiResponse apiResponse = ApiResponse.fromJson(response as Map<String, dynamic>);

    // Save API user info to SharedPreferences
    await SharedPrefService.storeUserApiInfo(apiResponse);

    token = apiResponse.token;
    userId = int.parse(apiResponse.apiUserId);
    name = apiResponse.apiUsername;

    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    await SharedPrefService.clearUserApiInfo();
    isAuthenticated = false;
    notifyListeners();
  }
}
// import 'package:flutter/foundation.dart';
// import 'package:malaria_report_mobile/services/api.dart';
// import 'package:malaria_report_mobile/services/shared_preferences.dart';

// class AuthProvider extends ChangeNotifier {
//   bool isAuthenticated = false;
//   late String token;
//   late int userId;
//   late String name;
//   late String township;
//   late ApiService apiService;

//   AuthProvider() {
//     init(); //instantiating the ApiService class
//   }

//   Future<void> init() async {
//     token =
//         await SharedPrefService()
//             .getToken(); //shared preferences to get the token
//     if (token.isNotEmpty) {
//       isAuthenticated = true;
//     }
//     apiService = ApiService(token);
//     notifyListeners(); //use notifyListeners() to notify the listeners of the change in the state

//     userId = await SharedPrefService().getUserId();
//     name = await SharedPrefService().getName();
//   }

//   //  Future<Map<String, dynamic>> login(String email, String password) async {
//   //   final response = await apiService.login(email, password);

//   //   // Get values from API response
//   //   final userData = {
//   //     'username': response['username'],
//   //     'email': response['email'],
//   //     'userId': response['id'].toString(), // Convert to string
//   //     'township': response['township'],
//   //   };

//   //   // Update local state
//   //   token = apiService.token;
//   //   userId = int.parse(userData['userId']!);
//   //   name = userData['username']!;
//   //   township = userData['township']!;

//   //   // Save to shared preferences
//   //   await SharedPrefService().setToken(token);
//   //   await SharedPrefService().setUserId(userId);
//   //   await SharedPrefService().setName(name);

//   //   isAuthenticated = true;
//   //   notifyListeners();

//   //   return userData; // Return the parsed data
//   // }
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final userData = await apiService.login(email, password);

//     // Update local state with null checks
//     token = userData['token'] ?? '';
//     userId = int.tryParse(userData['userId']?.toString() ?? '0') ?? 0;
//     name = userData['username'] ?? '';
//     township = userData['township'] ?? '';

//     // Save to shared preferences
//     await SharedPrefService().setToken(token);
//     await SharedPrefService().setUserId(userId);
//     await SharedPrefService().setName(name);

//     isAuthenticated = true;
//     notifyListeners();

//     return userData;
//   }

//   Future<void> logOut() async {
//     SharedPrefService().setToken('');
//     SharedPrefService().setUserId(0);
//     SharedPrefService().setName('');

//     isAuthenticated = false;
//     notifyListeners();
//   }
// }
