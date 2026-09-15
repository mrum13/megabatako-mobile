import 'package:equatable/equatable.dart';

class ReportByIdEntity extends Equatable {
  const ReportByIdEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.note,
    required this.date,
    required this.productName,
    required this.productThumbnail
  });

  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final String note;
  final String date;
  final String productName;
  final String productThumbnail;

  @override
  List<Object> get props => [
    id,
    userId,
    productId,
    quantity,
    note,
    date,
    productName,
    productThumbnail
  ];
}