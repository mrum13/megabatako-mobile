import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/panjar/domain/entities/store_panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/repositories/panjar_repository.dart';

class StorePanjarUseCase {
  final PanjarRepository repository;

  StorePanjarUseCase(this.repository);

  Future<Either<Failure, bool>> call({required StorePanjarEntity data}) {
    return repository.storePanjar(data: data);
  }
}