import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/products/domain/entities/product_entity.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, bool>> storeProduct({required StoreProductEntity data});
  Future<Either<Failure, List<ProductEntity>>> getProductByCategory({required int productCategoryId});
  Future<Either<Failure, bool>> deleteProduct({required int idProduct});
  Future<Either<Failure, bool>> updateProduct({required StoreProductEntity data, required int idProduct});
}