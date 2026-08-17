import 'package:megabatako/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id, 
    required super.productCategoryId,
    required super.name,
    required super.description,
    required super.price,
    required super.stock,
    required super.thumbnail,
    required super.categoryName
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel(
        id : json["id"],
        productCategoryId : json["product_category_id"],
        name : json["name"],
        description : json["description"],
        price : json["price"],
        stock : json["stock"],
        thumbnail : json["thumbnail"],
        categoryName: json["category_name"]
      );
}