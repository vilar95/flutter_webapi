import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class AuthService {
  //TODO: Modularizar o endpoint
  static const String url = "http://172.23.64.1:3000/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}login'), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 400 &&
        json.decode(response.body) == "Cannot find user") {
      throw UserNotFoundException();
    }

    if (response.statusCode != 200) {
      throw const HttpException("");
    }

    return true;
  }

  register({
    required String email,
    required String password,
  }) async {
    http.Response response =
        await client.post(Uri.parse('${url}register'), body: {
      'email': email,
      'password': password,
    });
  }
}

class UserNotFoundException implements Exception {}
class UserAlreadyExists implements Exception {}
