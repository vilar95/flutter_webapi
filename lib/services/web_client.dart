import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class WebClient {
  static const String url = "http://192.168.3.8:3000/";
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()], requestTimeout: const Duration(seconds: 5 ));

}