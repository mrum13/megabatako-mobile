import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:megabatako/core/api/api_helper.dart';
import 'package:megabatako/core/api/list_api.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/features/employee/data/models/employee_model.dart';
import 'package:megabatako/features/employee/data/models/form_employee_model.dart';
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getListEmployee();
  Future<bool> deleteEmployee({required int id});
  Future<bool> storeEmployee({required FormEmployeeModel data});
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final http.Client client;
  final SecureStorageService pref;

  EmployeeRemoteDataSourceImpl({required this.client, required this.pref});

  @override
  Future<List<EmployeeModel>> getListEmployee() async {
    final token = await pref.getToken();
    Uri url = Uri.parse('${URLs.url}${ListAPI.employee}');
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
      return rawData.map((e) => EmployeeModel.fromJson(e)).toList();
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
  Future<bool> deleteEmployee({required int id}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.deleteEmployee(id)}',
    );
    late final http.Response response;

    try {
      response = await client
          .delete(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
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
  Future<bool> storeEmployee({required FormEmployeeModel data}) async {
    final token = await pref.getToken();
    Uri url = Uri.parse(
      '${URLs.url}${ListAPI.storeEmployee}',
    );
    late final http.Response response;

    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: {
              'name': data.name,
              'email': data.email,
              'password': data.password,
              'role': data.role
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
