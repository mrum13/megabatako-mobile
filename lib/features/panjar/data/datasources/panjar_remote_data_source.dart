import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/panjar/data/models/panjar_model.dart';
import 'package:megabatako/features/panjar/data/models/store_panjar_model.dart';
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';

abstract class PanjarRemoteDataSource {
  Future<bool> storePanjar({required StorePanjarModel data});
  Future<PanjarModel> getPanjarById({required int userId});
}

class PanjarRemoteDataSourceImpl implements PanjarRemoteDataSource {
  final http.Client client;
  final SecureStorageService pref;

  PanjarRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storePanjar({required StorePanjarModel data}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.storePanjar}');
    late final http.Response response;

    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': data.userId,
              'quantity': data.quantity,
              'description': data.note,
              'date_time': data.date,
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // hanya network-level error (SocketException, timeout, dll) yang ketangkep di sini
      throw http.ClientException(e.toString());
    }

    if (response.statusCode == 201) {
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
          throw ServerException();
      }
    }
  }

  @override
  Future<PanjarModel> getPanjarById({required int userId}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.panjarById(userId)}');
    late final http.Response response;

    try {
      response = await client
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final rawData = jsonDecode(response.body)['data'];
        return PanjarModel.fromJson(rawData);
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
            throw ServerException();
        }
      }
    } on ServerException catch (e, s) {
      DMethod.log("$e | $s");
      rethrow;
    } catch (e) {
      throw http.ClientException(e.toString());
    }
  }
}
