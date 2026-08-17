import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/category/data/models/category_model.dart';
import 'package:megabatako/features/products/data/models/product_model.dart';
import 'package:megabatako/features/products/data/models/store_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProductRemoteDataSource {
  Future<bool> storeProductCategory({required StoreProductModel data});
  Future<List<ProductModel>> getProductByCategory({
    required int productCategoryId,
  });
  Future<bool> deleteProduct({required int id});
  Future<bool> updateProductCategory({
    required StoreProductModel data,
    required int idProduct,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  ProductRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storeProductCategory({required StoreProductModel data}) async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.storeProduct}');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${pref.getString('token')}',
      });

      request.fields['product_category_id'] = data.productCategoryId.toString();
      request.fields['name'] = data.name;
      request.fields['price'] = data.price.toString();
      request.fields['stock'] = data.stock.toString();
      request.fields['description'] = data.desc;

      if (data.thumbnail != null) {
        request.files.add(
          await http.MultipartFile.fromPath('thumbnail', data.thumbnail!),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 10),
      );
      final response = await http.Response.fromStream(streamedResponse);

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
    } catch (e) {
      throw http.ClientException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductByCategory({
    required int productCategoryId,
  }) async {
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.getProductByCategory(productCategoryId)}',
    );
    late final http.Response response;

    try {
      response = await client
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${pref.getString('token')}',
            },
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw http.ClientException(e.toString());
    }

    if (response.statusCode == 200) {
      List rawData = jsonDecode(response.body)['data'];
      return rawData.map((e) => ProductModel.fromJson(e)).toList();
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
  Future<bool> deleteProduct({required int id}) async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.deleteProduct(id)}');
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
  Future<bool> updateProductCategory({
    required StoreProductModel data,
    required int idProduct,
  }) async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.updateProduct(idProduct)}');

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${pref.getString('token')}',
      });

      request.fields['product_category_id'] = data.productCategoryId.toString();
      request.fields['name'] = data.name;
      request.fields['price'] = data.price.toString();
      request.fields['stock'] = data.stock.toString();
      request.fields['description'] = data.desc;

      if (data.thumbnail != "") {
        request.files.add(
          await http.MultipartFile.fromPath('thumbnail', data.thumbnail!),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 10),
      );
      final response = await http.Response.fromStream(streamedResponse);

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
    } catch (e) {
      throw http.ClientException(e.toString());
    }
  }
}
