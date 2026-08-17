part of 'image_picker_cubit.dart';

sealed class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object> get props => [];
}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickerLoading extends ImagePickerState {}

final class ImagePickerSuccess extends ImagePickerState {
  final ImagePickerEntity image;

  const ImagePickerSuccess(this.image);

  @override
  List<Object> get props => [image];
}

final class ImagePickerFailure extends ImagePickerState {
  final String message;

  const ImagePickerFailure(this.message);

  @override
  List<Object> get props => [message];
}