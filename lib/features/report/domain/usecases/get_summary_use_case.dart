import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/summary_withdraw_entity.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class GetSummaryUseCase {
  final ReportRepository repository;

  GetSummaryUseCase(this.repository);

  Future<Either<Failure, SummaryWithdrawEntity>> call({required int idEmployee}) {
    return repository.getSummary(idEmployee: idEmployee);
  }
}