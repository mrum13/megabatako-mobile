part of 'update_product_cubit.dart';

sealed class UpdateProductState extends Equatable {
  const UpdateProductState();

  @override
  List<Object> get props => [];
}

final class UpdateProductInitial extends UpdateProductState {}

final class UpdateProductLoading extends UpdateProductState {}

final class UpdateProductSuccess extends UpdateProductState {
  final bool status;

  const UpdateProductSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class UpdateProductFailed extends UpdateProductState {
  final String message;

  const UpdateProductFailed(this.message);

  @override
  List<Object> get props => [message];
}