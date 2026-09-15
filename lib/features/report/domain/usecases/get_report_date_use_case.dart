import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class GetReportDateUseCase {
  final ReportRepository repository;

  GetReportDateUseCase(this.repository);

  Future<Either<Failure, List<DateTime>>> call({required int idEmployee}) {
    return repository.getReportDateById(idEmployee: idEmployee);
  }
}