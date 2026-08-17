import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/category/domain/repositories/category_repository.dart';

class StoreProductCategoryUseCase {
  final CategoryRepository repository;

  StoreProductCategoryUseCase(this.repository);

  Future<Either<Failure, bool>> call({required String name}) {
    return repository.storeCategory(name: name);
  }
}