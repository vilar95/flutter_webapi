import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String url = WebClient.url;
  http.Client client = WebClient().client;

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}login'), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 200) {
      if (json.decode(response.body).toString() == "Cannot find user") {
        throw UserNotFoundException();
      }

      throw HttpException(response.body.toString());
    }

    return saveInfosFromResponse(response.body);
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    http.Response response =
        await client.post(Uri.parse('${url}register'), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
    await saveInfosFromResponse(response.body);
    return true;
  }

  Future<bool> saveInfosFromResponse(String body) async {
    Map<String, dynamic> map = json.decode(body);
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setString("accessToken", token) &&
        await prefs.setString("email", email) &&
        await prefs.setInt("id", id);
    return success;
  }
}

class UserNotFoundException implements Exception {}

class UserAlreadyExists implements Exception {}
