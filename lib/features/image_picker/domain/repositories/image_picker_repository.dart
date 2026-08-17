import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/image_picker/domain/entities/image_picker_entity.dart';

abstract class ImagePickerRepository {
  Future<Either<Failure, ImagePickerEntity>> takePicture();
  Future<Either<Failure, ImagePickerEntity>> choosePicture();
}