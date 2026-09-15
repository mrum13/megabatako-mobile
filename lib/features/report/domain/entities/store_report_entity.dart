import 'package:equatable/equatable.dart';

class StoreReportEntity extends Equatable {
  const StoreReportEntity({
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.note,
    required this.date,
  });

  final int userId;
  final int productId;
  final int quantity;
  final String note;
  final String date;

  @override
  List<Object> get props => [
    userId,
    productId,
    quantity,
    note,
    date,];
}