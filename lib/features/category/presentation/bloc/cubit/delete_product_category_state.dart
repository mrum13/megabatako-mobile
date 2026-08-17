part of 'delete_product_category_cubit.dart';

sealed class DeleteProductCategoryState extends Equatable {
  const DeleteProductCategoryState();

  @override
  List<Object> get props => [];
}

final class DeleteProductCategoryInitial extends DeleteProductCategoryState {}

final class DeleteProductCategoryLoading extends DeleteProductCategoryState {}

final class DeleteProductCategorySuccess extends DeleteProductCategoryState {
  final bool status;

  const DeleteProductCategorySuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class DeleteProductCategoryFailed extends DeleteProductCategoryState {
  final String message;

  const DeleteProductCategoryFailed(this.message);

  @override
  List<Object> get props => [message];
}
