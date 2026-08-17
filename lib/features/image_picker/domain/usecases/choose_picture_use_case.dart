import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/image_picker/domain/entities/image_picker_entity.dart';
import 'package:megabatako/features/image_picker/domain/repositories/image_picker_repository.dart';

class ChoosePictureUseCase {
  final ImagePickerRepository repository;

  ChoosePictureUseCase(this.repository);

  Future<Either<Failure, ImagePickerEntity>> call() {
    return repository.choosePicture();
  }
}