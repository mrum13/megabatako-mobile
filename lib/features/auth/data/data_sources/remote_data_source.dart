import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<bool> signin({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  AuthRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> signin({required String email, required String password}) async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.signIn}');
    late final http.Response response;

    try {
      response = await client
          .post(
            url,
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // hanya network-level error (SocketException, timeout, dll) yang ketangkep di sini
      throw http.ClientException(e.toString());
    }

    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      pref.setString("token", body['data']['token']);
      pref.setString("current_pass", password);
      return true;
    } else {
      final body = decodeResponseBody(response);
      switch (response.statusCode) {
        case 400:
          throw BadRequestException(body['message']);
        case 404:
          throw AuthenticationException(body['message']);
        case 422:
          throw RequestValidationException(body['message']);
        default:
          DMethod.log(
            response.statusCode.toString(),
            prefix: 'Server Exception Login',
          );
          throw ServerException();
      }
    }
  }
}
