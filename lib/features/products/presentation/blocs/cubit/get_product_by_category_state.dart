part of 'get_product_by_category_cubit.dart';

sealed class GetProductByCategoryState extends Equatable {
  const GetProductByCategoryState();

  @override
  List<Object> get props => [];
}

final class GetProductByCategoryInitial extends GetProductByCategoryState {}

final class GetProductByCategoryLoading extends GetProductByCategoryState {}

final class GetProductByCategorySuccess extends GetProductByCategoryState {
  final List<ProductEntity> data;

  const GetProductByCategorySuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetProductByCategoryFailed extends GetProductByCategoryState {
  final String message;

  const GetProductByCategoryFailed(this.message);

  @override
  List<Object> get props => [message];
}