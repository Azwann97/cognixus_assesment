import 'dart:convert';

import 'package:cognixus_task/controller/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  dynamic response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw UnauthorisedException(response.body.toString());
      default:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      // throw FetchDataException('Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
