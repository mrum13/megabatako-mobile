import 'package:equatable/equatable.dart';

class SummaryWithdrawEntity extends Equatable {
  final List<ItemData> data;
  final num totalEmployeeRate;

  const SummaryWithdrawEntity({
    required this.data,
    required this.totalEmployeeRate,
  });

  @override
  List<Object> get props => [
    data,
    totalEmployeeRate
  ];
}

class ItemData extends Equatable {
  const ItemData({
    required this.userId,
    required this.employeeName,
    required this.productName,
    required this.productThumbnail,
    required this.employeeRate,
    required this.totalQuantity,
    required this.subTotalEmployeeRate,
    required this.totalReports,
  });

  final int userId;
  final String employeeName;
  final String productName;
  final String productThumbnail;
  final num employeeRate;
  final num totalQuantity;
  final num subTotalEmployeeRate;
  final int totalReports;

  @override
  List<Object?> get props => [
    userId,
    employeeName,
    productName,
    productThumbnail,
    employeeRate,
    totalQuantity,
    subTotalEmployeeRate,
    totalReports,
  ];
}
