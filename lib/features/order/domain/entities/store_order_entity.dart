import 'package:equatable/equatable.dart';

class StoreOrderEntity extends Equatable {
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String paymentMethod;
  final String paymentScheme;
  final String downPayment;
  final bool pickupDelivery;
  final String date;
  final bool isFinish;
  final List<StoreOrderItemEntity> orderItem;

  const StoreOrderEntity({
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.paymentMethod,
    required this.paymentScheme,
    required this.downPayment,
    required this.pickupDelivery,
    required this.date,
    required this.isFinish,
    required this.orderItem,
  });

  @override
  List<Object?> get props => [
    customerName,
    customerPhone,
    customerAddress,
    paymentMethod,
    paymentScheme,
    pickupDelivery,
    date,
    isFinish,
    orderItem,
  ];
}

class StoreOrderItemEntity extends Equatable {
  final int productId;
  final int productQuantity;

  const StoreOrderItemEntity({
    required this.productId,
    required this.productQuantity,
  });

  @override
  List<Object?> get props => [productId, productQuantity];
}
