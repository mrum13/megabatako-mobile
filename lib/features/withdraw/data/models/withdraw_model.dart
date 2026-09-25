import 'package:megabatako/features/withdraw/domain/entities/withdraw_entity.dart';

class WithdrawModel extends WithdrawEntity {
  const WithdrawModel({required super.userId, required super.subtotal, required super.panjar, required super.total, required super.description, required super.dateTime});

  factory WithdrawModel.fromJson(Map<String, dynamic> json) =>
    WithdrawModel(
      userId: json["user_id"], 
      subtotal: json["subtotal"], 
      panjar: json["panjar"], 
      total: json["total"], 
      description: json["description"], 
      dateTime: json["date_time"]
    );
}