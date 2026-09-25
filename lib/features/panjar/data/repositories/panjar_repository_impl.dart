import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/panjar/data/datasources/panjar_remote_data_source.dart';
import 'package:megabatako/features/panjar/data/models/store_panjar_model.dart';
import 'package:megabatako/features/panjar/domain/entities/panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/entities/store_panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/repositories/panjar_repository.dart';

class PanjarRepositoryImpl implements PanjarRepository {
  final NetworkInfo networkInfo;
  final PanjarRemoteDataSource remoteDataSource;

  PanjarRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> storePanjar({
    required StorePanjarEntity data,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.storePanjar(
          data: StorePanjarModel(
            userId: data.userId,
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
  Future<Either<Failure, PanjarEntity>> getPanjarById({
    required int userId,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getPanjarById(userId: userId);
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
