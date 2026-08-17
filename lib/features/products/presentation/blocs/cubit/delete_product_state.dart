part of 'delete_product_cubit.dart';

sealed class DeleteProductState extends Equatable {
  const DeleteProductState();

  @override
  List<Object> get props => [];
}

final class DeleteProductInitial extends DeleteProductState {}

final class DeleteProductLoading extends DeleteProductState {}

final class DeleteProductSuccess extends DeleteProductState {
  final bool status;

  const DeleteProductSuccess(this.status);

  @override
  List<Object> get props => [];
}

final class DeleteProductFailed extends DeleteProductState {
  final String message; 

  const DeleteProductFailed(this.message);

  @override
  List<Object> get props => [message];
}
