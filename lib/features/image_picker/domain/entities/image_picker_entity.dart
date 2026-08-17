import 'dart:io';

import 'package:equatable/equatable.dart';

class ImagePickerEntity extends Equatable {
  final File file;
  final String path;
  final int? sizeInBytes;

  const ImagePickerEntity({
    required this.file,
    required this.path,
    this.sizeInBytes,
  });

  @override
  List<Object?> get props => [path, sizeInBytes];
}