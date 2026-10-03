// order_entity.dart
import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int productId;
  final int quantity;
  final int price;
  final String thumbnail;
  final String name;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.thumbnail,
    required this.name,
  });

  int get subtotal => price * quantity;

  @override
  List<Object?> get props => [id, productId, quantity, price, thumbnail, name];
}

class OrderEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerNumber;
  final String customerAddress;
  final String paymentMethod;
  final String paymentSchema;
  final double downPayment;
  final bool pickupDelivery;
  final bool isFinish;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerNumber,
    required this.customerAddress,
    required this.paymentMethod,
    required this.paymentSchema,
    required this.downPayment,
    required this.pickupDelivery,
    required this.isFinish,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  int get totalPrice => items.fold(0, (sum, e) => sum + e.subtotal);

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        customerName,
        customerNumber,
        customerAddress,
        paymentMethod,
        paymentSchema,
        downPayment,
        pickupDelivery,
        isFinish,
        date,
        createdAt,
        updatedAt,
        items,
      ];
}