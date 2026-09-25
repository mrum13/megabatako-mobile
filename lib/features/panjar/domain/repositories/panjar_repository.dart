import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/panjar/domain/entities/panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/entities/store_panjar_entity.dart';

abstract class PanjarRepository {
  Future<Either<Failure, bool>> storePanjar({required StorePanjarEntity data});
  Future<Either<Failure, PanjarEntity>> getPanjarById({required int userId});
}