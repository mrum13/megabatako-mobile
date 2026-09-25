import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/withdraw/domain/entities/store_withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/entities/withdraw_entity.dart';

abstract class WithdrawRepository {
  Future<Either<Failure, bool>> storeWithdraw({required StoreWithdrawEntity data});
  Future<Either<Failure, List<WithdrawEntity>>> getWithdraw({required int userId});
}