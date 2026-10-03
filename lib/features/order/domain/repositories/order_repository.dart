import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/order/domain/entities/order_entity.dart';
import 'package:megabatako/features/order/domain/entities/store_order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, bool>> storeData({required StoreOrderEntity data});
  Future<Either<Failure, List<OrderEntity>>> getData({required String date});
  Future<Either<Failure, bool>> updateOrderStatus({required int id});
}