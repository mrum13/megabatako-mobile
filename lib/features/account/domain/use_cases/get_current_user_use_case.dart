import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/account/domain/entities/user_entity.dart';
import 'package:megabatako/features/account/domain/repositories/account_repository.dart';

class GetCurrentUserUseCase {
  final AccountRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.currentUser();
  }
}