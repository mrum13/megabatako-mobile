import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/category/data/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryRemoteDataSource {
  Future<bool> storeProductCategory({required String name});
  Future<List<CategoryModel>> getProductCategory();
  Future<bool> deleteProductCategory({required int idCategory});
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  CategoryRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<List<CategoryModel>> getProductCategory() async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.getProductCategory}');
    late final http.Response response;

    try {
      response = await client
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // hanya network-level error (SocketException, timeout, dll) yang ketangkep di sini
      throw http.ClientException(e.toString());
    }

    if (response.statusCode == 200) {
      List rawData = jsonDecode(response.body)['data'];
      return rawData.map((e) => CategoryModel.fromJson(e)).toList();
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

  @override
  Future<bool> deleteProductCategory({required int idCategory}) async {
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.deleteProductCategory(idCategory)}',
    );
    late final http.Response response;

    try {
      response = await client
          .delete(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${pref.getString('token')}',
            },
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // hanya network-level error (SocketException, timeout, dll) yang ketangkep di sini
      throw http.ClientException(e.toString());
    }

    if (response.statusCode == 204) {
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
  Future<bool> storeProductCategory({required String name}) async {
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.storeProductCategory}',
    );
    late final http.Response response;

    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${pref.getString('token')}',
            },
            body: {
              "name": name
            }
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
}
