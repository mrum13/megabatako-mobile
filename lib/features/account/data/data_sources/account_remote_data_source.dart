import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/account/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountRemoteDataSource {
  Future<UserModel> getCurrentUser();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  AccountRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<UserModel> getCurrentUser() async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.currentUser}');
    final response = await client
        .get(
          url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${pref.getString('token')}',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      var rawData = jsonDecode(response.body)['data'];

      UserModel data =
            UserModel.fromJson(rawData);
        return data;
    } else {
      final body = decodeResponseBody(response); // Using the helper
      switch (response.statusCode) {
        case 400:
          throw BadRequestException(body['message']);
        case 404:
          throw AuthenticationException(body['message']);
        case 422:
          throw RequestValidationException(body['message']);
        default:
          throw ServerException();
      }
    }
  }
}
