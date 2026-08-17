import 'package:flutter/material.dart';
import 'package:megabatako/core/theme/app_colors.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Kerja"),
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}