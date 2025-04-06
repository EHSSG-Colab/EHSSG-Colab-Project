// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiService {
//   late String token;
//   late bool error;
//   late int userId;
//   late String name;
//   late String message;
//   late String errorMessage;

//   ApiService(String token) {
//     this.token = token;
//   }

//   final String baseUrl = 'https://z5meen0qec.sharedwithexpose.com/api/';

//   Future<void> login(String email, String password) async {
//     String uri = '${baseUrl}login';

//     try {
//       var response = await http.post(
//         Uri.parse(uri),
//         body: {'email': email, 'password': password},
//       );

//       var authResponse = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         token = authResponse['info']['token'] ?? '';
//         error = false;
//         userId = authResponse['info']['user_id'] ?? 0;
//         name = authResponse['info']['name'] ?? '';
//         message = authResponse['message'] ?? '';

//         // Save data to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setInt('userId', userId);
//         await prefs.setString('name', name);
//       } else {
//         error = true;
//         message = authResponse['message'] ?? 'Login failed';
//         errorMessage = authResponse['info'] ?? 'Unknown error';
//         throw Exception('$message. $errorMessage');
//       }
//     } catch (e) {
//       error = true;
//       message = 'Login failed';
//       errorMessage = e.toString();
//       throw Exception(errorMessage);
//     }
//   }

//   // Method to retrieve saved token
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   // Method to retrieve saved userId
//   Future<int?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('userId');
//   }

//   // Method to retrieve saved name
//   Future<String?> getName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('name');
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late String token;
  late bool error;
  late int userId;
  late String name;
  late String message;
  late String errorMessage;

  ApiService(String token) {
    this.token = token;
  }

  final String baseUrl = 'https://z5meen0qec.sharedwithexpose.com/api/';

  Future<void> login(String email, String password) async {
    String uri = '${baseUrl}login';

    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {'email': email, 'password': password},
      );

      var authResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        token = authResponse['info']['token'] ?? '';
        error = false;
        userId = authResponse['info']['user_id'] ?? 0;
        name = authResponse['info']['name'] ?? '';
        message = authResponse['message'] ?? '';

        // Save data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('userId', userId);
        await prefs.setString('name', name);
      } else {
        error = true;
        message = authResponse['message'] ?? 'Login failed';
        errorMessage = authResponse['info'] ?? 'Unknown error';
        throw Exception('$message. $errorMessage');
      }
    } catch (e) {
      error = true;
      message = 'Login failed';
      errorMessage = e.toString();
      throw Exception(errorMessage);
    }
  }

  // Method to retrieve saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to retrieve saved userId
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Method to retrieve saved name
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
}
