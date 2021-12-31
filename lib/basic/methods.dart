import 'dart:convert';

import 'package:flutter/services.dart';

import 'entities.dart';

const methods = Methods._();

class Methods {
  const Methods._();

  static const _channel = MethodChannel("methods");

  Future<String> _invoke(String method, dynamic params) async {
    String resp = await _channel.invokeMethod(
        "invoke",
        jsonEncode({
          "method": method,
          "params": params is String ? params : jsonEncode(params),
        }));
    var response = _Response.fromJson(jsonDecode(resp));
    if (response.errorMessage.isNotEmpty) {
      throw StateError(response.errorMessage);
    }
    return response.responseData;
  }

  Future<ComicsResponse> comics(String slug, String sortBy, int page) async {
    final rsp = await _invoke("comics", {
      "categories_slug": slug,
      "sort_by": sortBy,
      "page": page,
    });
    return ComicsResponse.fromJson(jsonDecode(rsp));
  }
}

class _Response {
  late String errorMessage;
  late String responseData;

  _Response.fromJson(Map json) {
    errorMessage = json["error_message"];
    responseData = json["response_data"];
  }
}
