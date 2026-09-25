import 'package:megabatako/features/report/domain/entities/summary_withdraw_entity.dart';

class SummaryWithdrawModel extends SummaryWithdrawEntity {
  const SummaryWithdrawModel({
    required super.data,
    required super.totalEmployeeRate 
  });
  
  factory SummaryWithdrawModel.fromJson(Map<String, dynamic> json) =>
      SummaryWithdrawModel(
        data : (json['data'] as List<dynamic>)
            .map((e) => ItemDataModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalEmployeeRate : json["total_employee_rate"],
      );
}

class ItemDataModel extends ItemData {
  const ItemDataModel({
    required super.userId,
    required super.employeeName,
    required super.productName,
    required super.productThumbnail,
    required super.employeeRate,
    required super.totalQuantity,
    required super.subTotalEmployeeRate,
    required super.totalReports,
  });
  
  factory ItemDataModel.fromJson(Map<String, dynamic> json) =>
      ItemDataModel(
        userId: json['user_id'],
        employeeName: json['employee_name'],
        productName: json['product_name'],
        productThumbnail: json['product_thumbnail'],
        employeeRate: json['employee_rate'],
        totalQuantity: json['total_quantity'],
        subTotalEmployeeRate: json['sub_total_employee_rate'],
        totalReports: json['total_reports'],
      );
}