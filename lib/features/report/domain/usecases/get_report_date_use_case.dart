import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/mark_date_entity.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class GetReportDateUseCase {
  final ReportRepository repository;

  GetReportDateUseCase(this.repository);

  Future<Either<Failure, List<MarkDateEntity>>> call({required int idEmployee}) {
    return repository.getReportDateById(idEmployee: idEmployee);
  }
}