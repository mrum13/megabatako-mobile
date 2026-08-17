import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/utils/formatter.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Pesanan",
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.surface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border,width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ORD-001",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Loster",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat(
                                "dd MMM yyyy, hh:mm",
                              ).format(DateTime.now()),
                              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppColors.textHint, size: 24,),
                                const SizedBox(width: 4,),
                                Text("Balosi"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.account_circle_rounded, color: AppColors.textHint, size: 24,),
                                const SizedBox(width: 4,),
                                Text("Ippang"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  Chip(
                                    backgroundColor: AppColors.success,
                                    label: Text(
                                      "Lunas",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    backgroundColor: AppColors.warning,
                                    label: Text(
                                      "DP",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    backgroundColor: AppColors.error,
                                    label: Text(
                                      "Belum",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8,),
                                  Chip(
                                    backgroundColor: AppColors.info,
                                    label: Text(
                                      "Butuh Pengantaran",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Text(indonesiaCurrency(value: "12500000"), style: GoogleFonts.inter(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.w700),textAlign: TextAlign.end,)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
