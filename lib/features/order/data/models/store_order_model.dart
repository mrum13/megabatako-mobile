// data/models/order_model.dart
import 'package:megabatako/features/order/domain/entities/store_order_entity.dart';

class StoreOrderItemModel extends StoreOrderItemEntity {
  const StoreOrderItemModel({
    required super.productId,
    required super.productQuantity,
  });

  // dari response server (key "items" berisi product_id, quantity, price)
  factory StoreOrderItemModel.fromJson(Map<String, dynamic> json) => StoreOrderItemModel(
        productId: json['product_id'] as int,
        productQuantity: json['quantity'] as int,
      );

  // untuk request
  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': productQuantity,
      };
}

class StoreOrderModel extends StoreOrderEntity {
  const StoreOrderModel({
    required super.customerName,
    required super.customerPhone,
    required super.customerAddress,
    required super.paymentMethod,
    required super.paymentScheme,
    required super.downPayment,
    required super.pickupDelivery,
    required super.isFinish,
    required super.date,
    required super.orderItem,
  });

  factory StoreOrderModel.fromJson(Map<String, dynamic> json) => StoreOrderModel(
        customerName: json['customer_name'] as String,
        customerPhone: json['customer_number'] as String,
        customerAddress: json['customer_address'] as String,
        paymentMethod: json['payment_method'] as String,
        paymentScheme: json['payment_schema'] as String,
        downPayment: json['down_payment'] as String,
        pickupDelivery: json['pickup_delivery'] as bool,
        isFinish: json['is_finish'] as bool? ?? false,
        date: json['date'] as String,
        // response Laravel memakai key "items", request memakai "products"
        orderItem: ((json['items'] ?? json['products']) as List? ?? [])
            .map((e) => StoreOrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // hasilnya sama persis dengan JSON yang Anda kirim
  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'customer_number': customerPhone,
        'customer_address': customerAddress,
        'payment_method': paymentMethod,
        'payment_schema': paymentScheme,
        'down_payment': downPayment,
        'pickup_delivery': pickupDelivery,
        'is_finish': isFinish,
        'date': date,
        'products': orderItem
            .map((e) => StoreOrderItemModel(
                  productId: e.productId,
                  productQuantity: e.productQuantity,
                ).toJson())
            .toList(),
      };
}