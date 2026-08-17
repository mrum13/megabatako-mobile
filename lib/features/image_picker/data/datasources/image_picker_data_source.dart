import 'dart:io';

import 'package:image_picker/image_picker.dart' as ip;
import 'package:megabatako/core/errors/expentions.dart';

abstract class ImagePickerDataSource {
  Future<File?> pickImage({required ip.ImageSource source});
}

class ImagePickerDataSourceImpl implements ImagePickerDataSource {
  final ip.ImagePicker _picker;

  ImagePickerDataSourceImpl({ip.ImagePicker? picker})
    : _picker = picker ?? ip.ImagePicker();

  @override
  Future<File?> pickImage({required ip.ImageSource source}) async {
    try {
      final ip.XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (xFile == null) {
        // User membatalkan pemilihan gambar, bukan error.
        return null;
      }

      return File(xFile.path);
    } catch (e) {
      throw ImagePickerException('Gagal mengambil gambar: $e');
    }
  }
}
