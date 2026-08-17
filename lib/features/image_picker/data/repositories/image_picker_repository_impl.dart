import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/image_picker/data/datasources/image_picker_data_source.dart';
import 'package:megabatako/features/image_picker/domain/entities/image_picker_entity.dart';
import 'package:megabatako/features/image_picker/domain/repositories/image_picker_repository.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePickerDataSource dataSource;

  const ImagePickerRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, ImagePickerEntity>> takePicture() async {
    return _pick(
      source: ip.ImageSource.camera,
    );
  }

  @override
  Future<Either<Failure, ImagePickerEntity>> choosePicture() async {
    return _pick(
      source: ip.ImageSource.gallery,
    );
  }

  Future<Either<Failure, ImagePickerEntity>> _pick({
    required ip.ImageSource source
  }) async {
    try {
      final file = await dataSource.pickImage(
        source: source
      );

      if (file == null) {
        return const Left(ImagePickFailure('Pemilihan gambar dibatalkan'));
      }

      final length = await file.length();

      return Right(
        ImagePickerEntity(file: file, path: file.path, sizeInBytes: length),
      );
    } on ImagePickerException catch (e) {
      return Left(ImagePickFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Terjadi kesalahan tak terduga: $e'));
    }
  }
}
