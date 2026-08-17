part of 'store_product_category_cubit.dart';

sealed class StoreProductCategoryState extends Equatable {
  const StoreProductCategoryState();

  @override
  List<Object> get props => [];
}

final class StoreProductCategoryInitial extends StoreProductCategoryState {}

final class StoreProductCategoryLoading extends StoreProductCategoryState {}

final class StoreProductCategorySuccess extends StoreProductCategoryState {
  final bool status;

  const StoreProductCategorySuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreProductCategoryFailed extends StoreProductCategoryState {
  final String message;

  const StoreProductCategoryFailed(this.message);

  @override
  List<Object> get props => [message];
}