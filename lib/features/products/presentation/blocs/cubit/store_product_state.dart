part of 'store_product_cubit.dart';

sealed class StoreProductState extends Equatable {
  const StoreProductState();

  @override
  List<Object> get props => [];
}

final class StoreProductInitial extends StoreProductState {}

final class StoreProductLoading extends StoreProductState {}

final class StoreProductSuccess extends StoreProductState {
  final bool status;

  const StoreProductSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreProductFailed extends StoreProductState {
  final String message;

  const StoreProductFailed(this.message);

  @override
  List<Object> get props => [message];
}