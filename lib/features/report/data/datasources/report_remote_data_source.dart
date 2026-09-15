import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/report/data/models/report_by_id_model.dart';
import 'package:megabatako/features/report/data/models/store_report_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReportRemoteDataSource {
  Future<bool> storeReport({required StoreReportModel data});
  Future<List<ReportByIdModel>> getReportById({
    required int idEmployee,
    required String date,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final http.Client client;
  final SharedPreferences pref;

  ReportRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storeReport({required StoreReportModel data}) async {
    Uri url = Uri.parse('${URLs.url}${ListAPI.storeReport}');
    late final http.Response response;

    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${pref.getString('token')}',
            },
            body: jsonEncode({
              'user_id': data.userId,
              'product_id': data.productId,
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
  Future<List<ReportByIdModel>> getReportById({
    required int idEmployee,
    required String date,
  }) async {
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.getReportById(idEmployee, date)}',
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
      return rawData.map((e) => ReportByIdModel.fromJson(e)).toList();
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
