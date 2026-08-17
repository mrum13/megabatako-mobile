import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, bool>> storeCategory({required String name});
  Future<Either<Failure, List<CategoryEntity>>> listCategory();
  Future<Either<Failure, bool>> deleteCategory({required int idCategory});
}