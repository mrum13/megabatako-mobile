import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/products/domain/entities/product_entity.dart';
import 'package:megabatako/features/products/domain/repositories/product_repository.dart';

class GetProductByCategoryUseCase {
  final ProductRepository repository;

  GetProductByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({required int productCategoryId}) {
    return repository.getProductByCategory(productCategoryId: productCategoryId);
  }
}