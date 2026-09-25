import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/panjar/domain/entities/panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/repositories/panjar_repository.dart';

class GetPanjarUseCase {
  final PanjarRepository repository;

  GetPanjarUseCase(this.repository);

  Future<Either<Failure, PanjarEntity>> call({required int userId}) {
    return repository.getPanjarById(userId: userId);
  }
}