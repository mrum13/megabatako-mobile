import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/order/domain/entities/store_order_entity.dart';
import 'package:megabatako/features/order/domain/repositories/order_repository.dart';

class StoreOrderUseCase {
  final OrderRepository _orderRepository;

  StoreOrderUseCase(this._orderRepository);

  Future<Either<Failure, bool>> call({required StoreOrderEntity data}) {
    return _orderRepository.storeData(data: data);
  }
}
