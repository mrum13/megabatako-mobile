import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, bool>> storeReport({required StoreReportEntity data});
  Future<Either<Failure, List<ReportByIdEntity>>> getReportByIdAndDate({required int idEmployee, required String date});
  Future<Either<Failure, List<DateTime>>> getReportDateById({required int idEmployee});
}