import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  String token; // removed late keyword to make the token optional
  late bool error;
  late int userId;
  late String name;
  late String message;
  late String errorMessage;

  // constructor class is refactored. Made the token optional as the new user may not have a token during the first time login.
  ApiService({this.token = ''});

  final String baseUrl =
      'https://9ebpir2cpn.sharedwithexpose.com/api/'; // replace with your laravel herd url

  Future<void> login(String email, String password) async {
    String uri = '${baseUrl}login';

    // api call is wrapped in a try catch block
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
      } else {
        error = true;
        message = authResponse['message'] ?? 'Login failed';
        errorMessage = authResponse['info'] ?? 'Unknown error';
        throw Exception(
          '$message. $errorMessage',
        ); //throw an exception if the response is not successful alerting the user of the error
      }
    } catch (e) {
      error = true;
      message = 'Logi failed';
      errorMessage = e.toString();
      throw Exception(errorMessage);
    }
  }
}
