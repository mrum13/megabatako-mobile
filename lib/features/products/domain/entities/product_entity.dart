import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.productCategoryId,
    required this.name,
    required this.price,
    required this.thumbnail,
    required this.stock,
    required this.description,
    required this.categoryName
  });

  final int id;
  final int productCategoryId;
  final String name;
  final num price;
  final String thumbnail;
  final int stock;
  final String description;
  final String categoryName;

  @override
  List<Object> get props => [
    id,
    productCategoryId,
    name,
    price,
    thumbnail,
    stock,
    description,
    categoryName
  ];
}