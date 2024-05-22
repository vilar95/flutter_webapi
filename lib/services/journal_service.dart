import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;


class JournalService {
  static const String resource = "journals/";

  String url = WebClient.url;
  http.Client client = WebClient().client;

   String getUrl() {
    return "$url$resource";
  }

// Registro POST
  Future<bool> register(Journal journal, String token) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: journalJSON,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenExpiredException();
      }
      throw HttpException(response.body);
    }

    return true;
  }

// Requisição PUT
  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenExpiredException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

// Requisição GET
  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenExpiredException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(
        Journal.fromMap(jsonMap),
      );
    }
    log(list.length);

    return list;
  }

// Requisição DELETE
  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
      Uri.parse(
        "${getUrl()}$id",
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenExpiredException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
  
}

class TokenExpiredException implements Exception {}
