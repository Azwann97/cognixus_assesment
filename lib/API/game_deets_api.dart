import 'dart:io';

import 'package:cognixus_task/controller/api_exception.dart';
import 'package:cognixus_task/controller/api_manager.dart';
import 'package:cognixus_task/controller/global_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameDeetsApi {
  getShortDesc({required String page, required String dateRange}) async {
    String url = GlobalString().gameListApiURL.replaceAll("{page}", page).replaceAll("{dateRange}", dateRange);
    debugPrint("api url : $url");
    var responseJson = {};
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30), onTimeout: () {
        debugPrint("Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      responseJson = ApiManager().response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  getFullDesc({required String gameID}) async {
    String url = GlobalString().gameDetailsApiURL.replaceAll("{gameID}", gameID);
    debugPrint("api url : $url");
    var responseJson = {};
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30), onTimeout: () {
        debugPrint("Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      responseJson = ApiManager().response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}
