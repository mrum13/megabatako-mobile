import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/auth/data/data_sources/remote_data_source.dart';
import 'package:megabatako/features/auth/domain/repositories/auth_repository.dart';
import 'package:megabatako/features/secure_storage_service/data/datasources/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.secureStorageService
  });

  @override
  Future<Either<Failure, bool>> signin({
    required String email,
    required String password,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.signin(
          email: email,
          password: password,
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
  Future<bool> getIsLoggedIn() async {
    return secureStorageService.isLoggedIn();
  }

  @override
  Future<bool> signOut() async {
    return secureStorageService.clearToken().then((value) => true,);
  }
}
