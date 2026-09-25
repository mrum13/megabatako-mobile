import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/report/data/models/mark_date_model.dart';
import 'package:megabatako/features/report/data/models/report_by_id_model.dart';
import 'package:megabatako/features/report/data/models/store_report_model.dart';
import 'package:megabatako/features/report/data/models/summary_withdraw_model.dart';
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';

abstract class ReportRemoteDataSource {
  Future<bool> storeReport({required StoreReportModel data});
  Future<List<ReportByIdModel>> getReportById({
    required int idEmployee,
    required String date,
  });
  Future<List<MarkDateModel>> getReportDateById({required int idEmployee});
  Future<SummaryWithdrawModel> getSummary({required int idEmployee});
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final http.Client client;
  final SecureStorageService pref;

  ReportRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<bool> storeReport({required StoreReportModel data}) async {
    
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.storeReport}');
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
              'product_id': data.productId,
              'quantity': data.quantity,
              'description': data.note,
              'date_time': data.date,
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e,s) {
      throw http.ClientException(" | $s");
      
    }

    if (response.statusCode == 201) {
      return true;
    } else {
      final body = decodeResponseBody(response);
      DMethod.log(body['message']);
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
    final token = await pref.getToken();
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.getReportByIdAndDate(idEmployee, date)}',
    );
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

  @override
  Future<List<MarkDateModel>> getReportDateById({required int idEmployee}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.getReportDateById(idEmployee)}');
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

    if (response.statusCode == 200) {
      List rawData = jsonDecode(response.body)['data'];
      return rawData.map((e) => MarkDateModel.fromJson(e)).toList();
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
  Future<SummaryWithdrawModel> getSummary({required int idEmployee}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.getSummary(idEmployee)}');
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

    if (response.statusCode == 200) {
      final  rawData = jsonDecode(response.body);
      return SummaryWithdrawModel.fromJson(rawData);
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
