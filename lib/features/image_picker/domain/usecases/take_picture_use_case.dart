import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/image_picker/domain/entities/image_picker_entity.dart';
import 'package:megabatako/features/image_picker/domain/repositories/image_picker_repository.dart';

class TakePictureUseCase {
  final ImagePickerRepository repository;

  TakePictureUseCase(this.repository);

  Future<Either<Failure, ImagePickerEntity>> call() {
    return repository.takePicture();
  }
}