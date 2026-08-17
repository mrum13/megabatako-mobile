import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';
import 'package:megabatako/features/products/domain/repositories/product_repository.dart';

class StoreProductUseCase {
  final ProductRepository repository;

  StoreProductUseCase(this.repository);

  Future<Either<Failure, bool>> call({required StoreProductEntity data}) {
    return repository.storeProduct(data: data);
  }
}