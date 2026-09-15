import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';

class StoreReportModel extends StoreReportEntity {
  const StoreReportModel({
    required super.productId,
    required super.userId,
    required super.quantity,
    required super.note,
    required super.date,
  });
}