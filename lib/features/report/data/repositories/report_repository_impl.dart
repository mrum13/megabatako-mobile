import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/data/datasources/report_remote_data_source.dart';
import 'package:megabatako/features/report/data/models/store_report_model.dart';
import 'package:megabatako/features/report/domain/entities/mark_date_entity.dart';
import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';
import 'package:megabatako/features/report/domain/entities/summary_withdraw_entity.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final NetworkInfo networkInfo;
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> storeReport({
    required StoreReportEntity data,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.storeReport(
          data: StoreReportModel(
            userId: data.userId,
            productId: data.productId,
            quantity: data.quantity,
            note: data.note,
            date: data.date,
          ),
        );
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, List<ReportByIdEntity>>> getReportByIdAndDate({
    required int idEmployee,
    required String date,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getReportById(idEmployee: idEmployee, date: date);
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, List<MarkDateEntity>>> getReportDateById({required int idEmployee}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getReportDateById(idEmployee: idEmployee);
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, SummaryWithdrawEntity>> getSummary({required int idEmployee}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getSummary(idEmployee: idEmployee);
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

}
