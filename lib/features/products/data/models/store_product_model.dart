import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';

class StoreProductModel extends StoreProductEntity {
  const StoreProductModel({
    required super.productCategoryId,
    required super.name,
    required super.price,
    required super.desc,
    required super.thumbnail,
    required super.stock,
  });

  Map<String, dynamic> toJson() => {
    "product_category_id": productCategoryId,
    "name": name,
    "price": price,
    "thumbnail": thumbnail,
    "stock": stock,
    "description": desc,
  };
}
