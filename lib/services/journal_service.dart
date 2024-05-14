import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptors';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = "http://localhost:3000/";
  static const String resourse = "learnhttp/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$url$resourse";
  }

  register(String content) {
    client.post(
      Uri.parse(getUrl()),
      body: json.encode({"content": content}),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
