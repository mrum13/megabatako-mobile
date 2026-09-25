import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';
import 'package:megabatako/features/withdraw/data/models/store_withdraw_model.dart';
import 'package:megabatako/features/withdraw/data/models/withdraw_model.dart';

abstract class WithdrawRemoteDataSource {
  Future<bool> storeWithdraw({required StoreWithdrawModel data});
  Future<List<WithdrawModel>> getWithdraw({required int userId});
}

class WithdrawRemoteDataSourceImpl implements WithdrawRemoteDataSource {
  final http.Client client;
  final SecureStorageService pref;

  WithdrawRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storeWithdraw({required StoreWithdrawModel data}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.storeWithdraw}');
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
              'subtotal': data.subtotal,
              'panjar': data.panjar,
              'total': data.total,
              'description': "-",
              'date_time': data.dateTime,
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e, s) {
      throw http.ClientException(" | $s");
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
  Future<List<WithdrawModel>> getWithdraw({required int userId}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.withdrawById(userId)}');
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
    } catch (e) {
      throw http.ClientException(e.toString());
    }

    DMethod.log(response.statusCode.toString());

    if (response.statusCode == 200) {
      List rawData = jsonDecode(response.body)['data'];
      return rawData.map((e) => WithdrawModel.fromJson(e)).toList();
    } else {
      final body = decodeResponseBody(response);
      switch (response.statusCode) {
        case 401:
          throw AuthenticationException(body['message']);
        case 404:
          throw NotFoundException(body['message']);
        default:
          throw ServerException();
      }
    }
  }
}
