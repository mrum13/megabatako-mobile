import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/order/data/models/order_model.dart';
import 'package:megabatako/features/order/data/models/store_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';

abstract class OrderRemoteDataSource {
  Future<bool> storeOrder({required StoreOrderModel data});
  Future<List<OrderModel>> getData({required String date});
  Future<bool> updateStatusOrder({required int id});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  final SecureStorageService pref;

  OrderRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storeOrder({required StoreOrderModel data}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.storeOrder}');
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
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return true;
      } else {
        final body = decodeResponseBody(response);
        switch (response.statusCode) {
          case 400:
            throw BadRequestException(body['message']);
          case 401:
            throw AuthenticationException(body['message']);
          case 404:
            throw NotFoundException(body['message']);
          case 422:
            throw RequestValidationException(body['message']);
          default:
            throw ServerException();
        }
      }
    } catch (e, s) {
      DMethod.log("STORE ORDER : $e | $s");
      throw http.ClientException(e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getData({required String date}) async {
    final token = await pref.getToken();
    final url = Uri.parse(
      '${URLs.url}${ListAPI.getOrder}',
    ).replace(queryParameters: {'date': date});

    try {
      final response = await client
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List rawData = jsonDecode(response.body)['data'];
        return rawData.map((e) => OrderModel.fromJson(e)).toList();
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

  @override
  Future<bool> updateStatusOrder({required int id}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.updateOrder(id)}');
    late final http.Response response;

    try {
      response = await client
          .patch(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({"is_finish": true, "payment_schema": "Lunas"}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else {
        final body = decodeResponseBody(response);
        switch (response.statusCode) {
          case 400:
            throw BadRequestException(body['message']);
          case 401:
            throw AuthenticationException(body['message']);
          case 404:
            throw NotFoundException(body['message']);
          case 422:
            throw RequestValidationException(body['message']);
          default:
            throw ServerException();
        }
      }
    } catch (e, s) {
      DMethod.log("Update ORDER : $e | $s");
      throw http.ClientException(e.toString());
    }
  }
}
