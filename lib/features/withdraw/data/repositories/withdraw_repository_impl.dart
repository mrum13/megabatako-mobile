import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/withdraw/data/datasources/withdraw_remote_data_source.dart';
import 'package:megabatako/features/withdraw/data/models/store_withdraw_model.dart';
import 'package:megabatako/features/withdraw/domain/entities/store_withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/entities/withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/repositories/withdraw_repository.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final NetworkInfo networkInfo;
  final WithdrawRemoteDataSource remoteDataSource;

  WithdrawRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> storeWithdraw({
    required StoreWithdrawEntity data,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.storeWithdraw(
          data: StoreWithdrawModel(
            userId: data.userId,
            subtotal: data.subtotal,
            panjar: data.panjar,
            total: data.total,
            dateTime: data.dateTime,
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
  Future<Either<Failure, List<WithdrawEntity>>> getWithdraw({
    required int userId,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getWithdraw(userId: userId);
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
