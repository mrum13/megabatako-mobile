import 'package:equatable/equatable.dart';

class WithdrawEntity extends Equatable {
  final int userId;
  final int subtotal;
  final int panjar;
  final int total;
  final String description;
  final String dateTime;

  const WithdrawEntity({
    required this.userId,
    required this.subtotal,
    required this.panjar,
    required this.total,
    required this.description,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    userId,
    subtotal,
    panjar,
    total,
    description,
    dateTime,
  ];
}
