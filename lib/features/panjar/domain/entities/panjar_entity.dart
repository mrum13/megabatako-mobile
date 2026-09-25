import 'package:equatable/equatable.dart';

class PanjarEntity extends Equatable {
  final List<Items> items;
  final num totalQuantity;

  const PanjarEntity({
    required this.items,
    required this.totalQuantity
  });

  @override
  List<Object?> get props => [
    items,
    totalQuantity
  ];
}

class Items extends Equatable {
  final int userId;
  final num quantity;
  final String note;
  final String date;
  final int isPaid;

  const Items({
    required this.userId,
    required this.quantity,
    required this.date,
    required this.note,
    required this.isPaid
  });

  @override
  List<Object?> get props => [
    userId,
    quantity,
    note,
    date,
    isPaid
  ];
}