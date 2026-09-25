import 'package:equatable/equatable.dart';

class StoreWithdrawEntity extends Equatable {
  final int userId;
  final String subtotal;
  final String panjar;
  final String total;
  final String dateTime;

  const StoreWithdrawEntity({
    required this.userId,
    required this.subtotal,
    required this.panjar,
    required this.total,
    required this.dateTime,
  });


  @override
  List<Object?> get props => [
    userId,
    subtotal,
    panjar,
    total,
    dateTime,
  ];
}