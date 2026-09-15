import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/home/data/models/stock_summary_model.dart';
import 'package:megabatako/features/home/domain/entities/stock_summary_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class HomeRemoteDataSource {
  Future<List<StockSummaryEntity>> getStockSummary();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  HomeRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<List<StockSummaryEntity>> getStockSummary() async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.stockSummary}');
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
      return rawData.map((e) => StockSummaryModel.fromJson(e)).toList();
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
