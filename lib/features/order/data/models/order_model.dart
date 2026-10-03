// order_model.dart


import 'package:megabatako/features/order/domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.price,
    required super.thumbnail,
    required super.name,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toInt(),
      thumbnail: json['thumbnail'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.customerName,
    required super.customerNumber,
    required super.customerAddress,
    required super.paymentMethod,
    required super.paymentSchema,
    required super.downPayment,
    required super.pickupDelivery,
    required super.isFinish,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      customerNumber: json['customer_number'] as String? ?? '',
      customerAddress: json['customer_address'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentSchema: json['payment_schema'] as String? ?? '',
      downPayment:
          double.tryParse(json['down_payment']?.toString() ?? '') ?? 0,
      pickupDelivery: json['pickup_delivery'] as bool? ?? false,
      isFinish: json['is_finish'] as bool? ?? false,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}