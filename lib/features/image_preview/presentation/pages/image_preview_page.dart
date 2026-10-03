import 'package:flutter/material.dart';
import 'package:megabatako/core/theme/app_colors.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final path = args['path'];
    final source = args['source'];
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.scaffoldBackground),
        ),
      ),
      body: Center(
        child: source == "network"
            ? Image.network(path, height: 500, width: double.infinity)
            : Image.asset(path, height: 500, width: double.infinity),
      ),
    );
  }
}
