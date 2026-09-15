import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class GetReportUseCase {
  final ReportRepository repository;

  GetReportUseCase(this.repository);

  Future<Either<Failure, List<ReportByIdEntity>>> call({required int idEmployee, required String date}) {
    return repository.getReportById(idEmployee: idEmployee, date: date);
  }
}