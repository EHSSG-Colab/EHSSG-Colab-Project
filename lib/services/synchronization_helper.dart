import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:malaria_case_report_01/database/database_helper.dart';


class SynchronizationHelper {
  // HANDLING DATA

  // Convert list object to json
  String convertToJson(List<Map<String, dynamic>> listObject) {
    return jsonEncode({'data': listObject});
  }

  /*
    * The post to API function can be found in api.dart
    * The update synced record function can be found in database_helper.dart
  */

  // HANDLING RESPONSE
  // Convert response body into a list of json objects
  List<Map<String, dynamic>> convertResponseBody(String responseBody) {
    // Initiate an empty list of json responses
    List<Map<String, dynamic>> jsonResponses = [];
    // Split the response body into individual json objects
    RegExp exp = RegExp(r'\{[^}]+\}');
    Iterable<Match> matches = exp.allMatches(responseBody);

    for (Match m in matches) {
      try {
        var jsonResponse = json.decode(m.group(0)!);
        jsonResponses.add(jsonResponse);
      } catch (e) {
        print('Error parsing JSON object: ${m.group(0)}');
      }
    }
    return jsonResponses;
  }

  // Process json responses and identify successful and failed uploads
  Map<String, dynamic> processJsonResponses(
    List<Map<String, dynamic>> jsonResponses,
    List<Map<String, dynamic>> uploadedData,
  ) {
    List<int> successfulIds = [];
    List<String> errors = [];

    for (var i = 0; i < jsonResponses.length; i++) {
      var jsonResponse = jsonResponses[i];
      if (jsonResponse['message'] == 'INSERT Success' ||
          jsonResponse['message'] == 'UPDATE Success') {
        if (i < uploadedData.length) {
          successfulIds.add(uploadedData[i]['id'] as int);
        }
      } else {
        errors.add(jsonResponse['message']);
      }
    }
    return {'successfulIds': successfulIds, 'errors': errors};
  }

  // Show notification based on the result
  void showResultNotification(List<int> successfulIds, List<String> errors) {
    if (errors.isEmpty) {
      EasyLoading.showSuccess('All uploads successful.');
    } else if (successfulIds.isNotEmpty) {
      EasyLoading.showInfo('Partial success. Some errors occured.');
    } else {
      EasyLoading.showError('Upload failed. ${errors.join(", ")}');
    }
  }

  // Main function to handle all tasks
  Future<bool> handleResponse(
    http.Response response,
    List<Map<String, dynamic>> uploadedData,
  ) async {
    // if http response code is successful
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // convert the response
      List<Map<String, dynamic>> jsonResponses = convertResponseBody(
        response.body,
      );

      // Process the responses
      final result = processJsonResponses(jsonResponses, uploadedData);
      List<int> successfulIds = result['successfulIds'];
      List<String> errors = result['errors'];

      // Update database for successful sync
      if (successfulIds.isNotEmpty) {
        await DatabaseHelper().updateAfterSync(successfulIds);
      }

      // show notification
      showResultNotification(successfulIds, errors);

      // return true if at lease some uploads are successful
      return successfulIds.isNotEmpty;
    } else {
      EasyLoading.showError('Error uploading data: ${response.statusCode}');
      return false;
    }
  }
}