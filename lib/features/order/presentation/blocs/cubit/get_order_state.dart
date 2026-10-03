part of 'get_order_cubit.dart';

sealed class GetOrderState extends Equatable {
  const GetOrderState();

  @override
  List<Object> get props => [];
}

final class GetOrderInitial extends GetOrderState {}

final class GetOrderLoading extends GetOrderState {}

final class GetOrderSuccess extends GetOrderState {
  final List<OrderEntity> data;

  const GetOrderSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetOrderFailed extends GetOrderState {
  final String message;

  const GetOrderFailed(this.message);

  @override
  List<Object> get props => [message];
}