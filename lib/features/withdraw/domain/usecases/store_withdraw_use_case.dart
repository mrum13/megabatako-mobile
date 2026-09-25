import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/withdraw/domain/entities/store_withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/repositories/withdraw_repository.dart';

class StoreWithdrawUseCase {
  final WithdrawRepository repository;

  StoreWithdrawUseCase(this.repository);

  Future<Either<Failure, bool>> call({required StoreWithdrawEntity data}) {
    return repository.storeWithdraw(data: data);
  }
}