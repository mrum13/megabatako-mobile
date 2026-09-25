import 'package:equatable/equatable.dart';

class MarkDateEntity extends Equatable {
  final String date;
  final int isPaid;

  const MarkDateEntity({
    required this.date,
    required this.isPaid
  }); 

  @override
  List<Object?> get props => [];

}