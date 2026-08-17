import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/account/data/data_sources/account_remote_data_source.dart';
import 'package:megabatako/features/account/domain/entities/user_entity.dart';
import 'package:megabatako/features/account/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final NetworkInfo networkInfo;
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getCurrentUser();
        return Right(result);
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } catch (e) {
        
        return Left(ServerFailure('Message : $e'));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }
}