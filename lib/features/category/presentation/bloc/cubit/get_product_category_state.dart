part of 'get_product_category_cubit.dart';

sealed class GetProductCategoryState extends Equatable {
  const GetProductCategoryState();

  @override
  List<Object> get props => [];
}

final class GetProductCategoryInitial extends GetProductCategoryState {}

final class GetProductCategoryLoading extends GetProductCategoryState {}

final class GetProductCategorySuccess extends GetProductCategoryState {
  final List<CategoryEntity> data;

  const GetProductCategorySuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetProductCategoryFailed extends GetProductCategoryState {
  final String message;

  const GetProductCategoryFailed(this.message);

  @override
  List<Object> get props => [message];
}
