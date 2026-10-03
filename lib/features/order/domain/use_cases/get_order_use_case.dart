import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/order/domain/entities/order_entity.dart';
import 'package:megabatako/features/order/domain/repositories/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository _orderRepository;

  GetOrderUseCase(this._orderRepository);

  Future<Either<Failure, List<OrderEntity>>> call({required String date}) {
    return _orderRepository.getData(date: date);
  }
}