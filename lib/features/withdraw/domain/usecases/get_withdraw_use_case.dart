import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/withdraw/domain/entities/withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/repositories/withdraw_repository.dart';

class GetWithdrawUseCase {
  final WithdrawRepository repository;

  GetWithdrawUseCase(this.repository);

  Future<Either<Failure, List<WithdrawEntity>>> call({required int userId}) {
    return repository.getWithdraw(userId: userId);
  }
}