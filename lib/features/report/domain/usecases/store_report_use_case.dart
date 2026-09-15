import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';
import 'package:megabatako/features/report/domain/repositories/report_repository.dart';

class StoreReportUseCase {
  final ReportRepository repository;

  StoreReportUseCase(this.repository);

  Future<Either<Failure, bool>> call({required StoreReportEntity data}) {
    return repository.storeReport(data: data);
  }
}