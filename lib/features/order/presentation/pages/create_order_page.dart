import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buat Pesanan",
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.surface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: Column(children: []),
      ),
    );
  }
}
