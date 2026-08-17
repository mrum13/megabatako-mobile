import 'dart:convert';

import 'package:http/http.dart' as http;

dynamic decodeResponseBody(http.Response response) {
  try {
    return jsonDecode(response.body);
  } catch (e) {
    // Handle cases where response.body is not valid JSON
    throw const FormatException("Invalid JSON in response body");
  }
}