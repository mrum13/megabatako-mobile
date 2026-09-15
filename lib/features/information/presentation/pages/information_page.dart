import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> informationData = [
      {
        'image': "assets/pickup.png",
        'title': "Minimal Pengantaran",
        'content':
            "Pengantaran dapat dilakukan jika memenuhi batas minimal pembelian.\nLOSTER = 20 pcs,\nBATAKO = 100 pcs",
      },
      {
        'image': "assets/map.png",
        'title': "Batas Pengantaran",
        'content':
            "Batas lokasi pengantaran bagian selatan adalah tojabi, ke arah utara adalah tobaku",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Informasi",
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.surface),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.scaffoldBackground),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(informationData[index]['image'], height: 56, width: 56,),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(informationData[index]['title'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),),
                          const SizedBox(height: 4,),
                          Text(informationData[index]['content'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: informationData.length,
        ),
      ),
    );
  }
}
