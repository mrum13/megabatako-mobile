import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/order/domain/repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository _orderRepository;

  UpdateOrderStatusUseCase(this._orderRepository);

  Future<Either<Failure, bool>> call({required int id}) {
    return _orderRepository.updateOrderStatus(id: id);
  }
}
