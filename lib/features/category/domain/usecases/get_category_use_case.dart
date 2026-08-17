import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/category/domain/entities/category_entity.dart';
import 'package:megabatako/features/category/domain/repositories/category_repository.dart';

class GetCategoryUseCase {
  final CategoryRepository repository;

  GetCategoryUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.listCategory();
  }
}