import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  late String token;
  late bool error;
  late int userId;
  late String name;
  late String message;
  late String errorMessage;

  ApiService(String token) {
    this.token = token;//assign the token to the token variable
  }

  final String baseUrl =
      'https://9ebpir2cpn.sharedwithexpose.com/api/'; // replace with your laravel herd url

  Future login(String email, String password) async {
    String uri = '${baseUrl}login';

    var response = await http.post(
      Uri.parse(uri),
      body: {'email': email, 'password': password},
    );
    var authResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = authResponse['info']['token'] ?? '';
      error = false;
      userId = authResponse['info']['user_id'] ?? '';
      name = authResponse['info']['name'] ?? '';
      message = authResponse['message'] ?? '';
    } else {
      error = true;
      message = authResponse['message'] ?? '';
      errorMessage = authResponse['info'] ?? '';
      throw Exception('$message. $errorMessage');//throw an exception if the response is not successful alerting the user of the error
    }
  }
}
