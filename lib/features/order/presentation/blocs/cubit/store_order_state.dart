part of 'store_order_cubit.dart';

sealed class StoreOrderState extends Equatable {
  const StoreOrderState();

  @override
  List<Object> get props => [];
}

final class StoreOrderInitial extends StoreOrderState {}

final class StoreOrderLoading extends StoreOrderState {}

final class StoreOrderSuccess extends StoreOrderState {
  final bool status;

  const StoreOrderSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreOrderFailed extends StoreOrderState {
  final String message;

  const StoreOrderFailed(this.message);

  @override
  List<Object> get props => [message];
}
