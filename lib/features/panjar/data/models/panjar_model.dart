import 'package:megabatako/features/panjar/domain/entities/panjar_entity.dart';

class PanjarModel extends PanjarEntity {
  const PanjarModel({
    required super.items,
    required super.totalQuantity 
  });
  
  factory PanjarModel.fromJson(Map<String, dynamic> json) =>
      PanjarModel(
        items : (json['items'] as List<dynamic>)
            .map((e) => ItemsModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalQuantity : json["total_quantity"],
      );
}

class ItemsModel extends Items {
  const ItemsModel({
    required super.userId,
    required super.quantity,
    required super.date,
    required super.note,
    required super.isPaid
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) =>
      ItemsModel(
        userId: json["user_id"],
        quantity: json["quantity"],
        note: json["description"],
        date: json["date_time"],
        isPaid: json["is_paid"]
      );
}
