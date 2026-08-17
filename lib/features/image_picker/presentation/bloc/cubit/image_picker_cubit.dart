import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/image_picker/domain/entities/image_picker_entity.dart';
import 'package:megabatako/features/image_picker/domain/usecases/choose_picture_use_case.dart';
import 'package:megabatako/features/image_picker/domain/usecases/take_picture_use_case.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final TakePictureUseCase takePictureUseCase;
  final ChoosePictureUseCase choosePictureUseCase;

  ImagePickerCubit({
    required this.takePictureUseCase,
    required this.choosePictureUseCase,
  }) : super(ImagePickerInitial());

  Future<void> pickFromCamera({int? imageQuality = 85}) async {
    emit(ImagePickerLoading());

    final result = await takePictureUseCase();

    result.fold(
      (failure) => emit(ImagePickerFailure(failure.message)),
      (image) => emit(ImagePickerSuccess(image)),
    );
  }

  Future<void> pickFromGallery({int? imageQuality = 85}) async {
    emit(ImagePickerLoading());

    final result = await choosePictureUseCase();

    result.fold(
      (failure) => emit(ImagePickerFailure(failure.message)),
      (image) => emit(ImagePickerSuccess(image)),
    );
  }


  void reset() => emit(ImagePickerInitial());
}
