import 'package:megabatako/features/report/domain/entities/mark_date_entity.dart';

class MarkDateModel extends MarkDateEntity {
  const MarkDateModel({required super.date, required super.isPaid});

  factory MarkDateModel.fromJson(Map<String, dynamic> json) =>
    MarkDateModel(
      date : json["date"],
      isPaid: json["is_paid"]
    );
}