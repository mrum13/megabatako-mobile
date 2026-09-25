import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/report/domain/entities/mark_date_entity.dart';
import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';
import 'package:megabatako/features/report/domain/entities/summary_withdraw_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, bool>> storeReport({required StoreReportEntity data});
  Future<Either<Failure, List<ReportByIdEntity>>> getReportByIdAndDate({required int idEmployee, required String date});
  Future<Either<Failure, List<MarkDateEntity>>> getReportDateById({required int idEmployee});
  Future<Either<Failure, SummaryWithdrawEntity>> getSummary({required int idEmployee});
}