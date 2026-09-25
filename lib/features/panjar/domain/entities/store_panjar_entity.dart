import 'package:equatable/equatable.dart';

class StorePanjarEntity extends Equatable {
  final int userId;
  final num quantity;
  final String note;
  final String date;

  const StorePanjarEntity({
    required this.userId,
    required this.quantity,
    required this.date,
    required this.note
  });

  @override
  List<Object?> get props => [
    userId,
    quantity,
    note,
    date,
  ];
}