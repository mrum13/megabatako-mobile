import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/account/domain/entities/user_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserEntity>> currentUser();
}