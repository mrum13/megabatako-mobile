import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';

class ReportByIdModel extends ReportByIdEntity {
  const ReportByIdModel({
    required super.id, 
    required super.productId,
    required super.userId,
    required super.quantity,
    required super.note,
    required super.date,
    required super.productName,
    required super.productThumbnail
  });
  
  factory ReportByIdModel.fromJson(Map<String, dynamic> json) =>
      ReportByIdModel(
        id : json["id"],
        productId : json["product_id"],
        userId : json["user_id"],
        quantity : json["quantity"],
        note : json["description"],
        date : json["date_time"],
        productName : json["product_name"],
        productThumbnail: json["product_thumbnail"]
      );
}