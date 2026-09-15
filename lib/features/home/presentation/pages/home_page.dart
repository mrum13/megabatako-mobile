import 'package:d_method/d_method.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/home/presentation/blocs/cubit/get_stock_summary_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/blocs/cubit/navbar_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  List<PieChartSectionData> _buildSections() {
    final data = [
      {'value': 40.0, 'color': Colors.blue, 'title': 'A'},
      {'value': 30.0, 'color': Colors.red, 'title': 'B'},
      {'value': 15.0, 'color': Colors.green, 'title': 'C'},
      {'value': 15.0, 'color': Colors.orange, 'title': 'D'},
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 90.0 : 70.0;
      final fontSize = isTouched ? 20.0 : 14.0;
      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: data[i]['value'] as double,
        title: '${data[i]['value']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    final items = [
      {'color': Colors.blue, 'label': 'Loster A'},
      {'color': Colors.red, 'label': 'Loster B'},
      {'color': Colors.green, 'label': 'Batako'},
      {'color': Colors.orange, 'label': 'Lainnya'},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(item['label'] as String),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountState = context.read<GetCurrentUserCubit>().state;
    final bool isSuperAdmin =
        accountState is GetCurrentUserSuccess &&
        (accountState.data.role == 'superadmin' ||
            accountState.data.role == 'owner');
    final bool isEmployee =
        accountState is GetCurrentUserSuccess &&
        accountState.data.role == 'employee';
    final int currentUserId = accountState is GetCurrentUserSuccess ? accountState.data.id : 0;
    final String currentUserName = accountState is GetCurrentUserSuccess ? accountState.data.name : "-";

    DMethod.log(isSuperAdmin.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/logo.png", height: 48, width: 48),
            const SizedBox(width: 12),
            Text(
              "Mega Batako",
              style: TextStyle(color: AppColors.textOnPrimary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Menu cepat",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (isEmployee && currentUserId!=0) {
                          
                          Navigator.pushNamed(
                              context,
                              AppRoutes.detailReportPage,
                              arguments: {
                                "id": currentUserId,
                                "name": currentUserName,
                              },
                            );
                        } else {
                          Navigator.pushNamed(context, AppRoutes.reportPage);
                        }
                      },
                      child: Container(
                        height: 112,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/report.png",
                              height: 36,
                              width: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Laporan Pekerja",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<NavbarCubit>().setPage(2);
                      },
                      child: Container(
                        height: 112,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/product.png",
                              height: 36,
                              width: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Produk",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.informationPage);
                      },
                      child: Container(
                        height: 112,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/information.png",
                              height: 36,
                              width: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Informasi",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isSuperAdmin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Statistik Penjualan",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 1,
                        centerSpaceRadius: 50,
                        sections: _buildSections(),
                      ),
                      duration: Duration(milliseconds: 150), // Optional
                      curve: Curves.linear, // Optional
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Ringkasan Stok",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: BlocBuilder<GetStockSummaryCubit, GetStockSummaryState>(
                builder: (context, state) {
                  if (state is GetStockSummarySuccess) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RingkasanStokWidget(
                                imagePath: state.data[0].thumbnail == "-"
                                    ? "-"
                                    : "${URLs.storageUrl}${state.data[0].thumbnail}",
                                title: state.data[0].categoryName,
                                value: state.data[0].totalStock,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RingkasanStokWidget(
                                imagePath: state.data[1].thumbnail == "-"
                                    ? "-"
                                    : "${URLs.storageUrl}${state.data[1].thumbnail}",
                                title: state.data[1].categoryName,
                                value: state.data[1].totalStock,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: RingkasanStokWidget(
                                imagePath: state.data[2].thumbnail == "-"
                                    ? "-"
                                    : "${URLs.storageUrl}${state.data[2].thumbnail}",
                                title: state.data[2].categoryName,
                                value: state.data[2].totalStock,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RingkasanStokWidget(
                                imagePath: state.data[3].thumbnail == "-"
                                    ? "-"
                                    : "${URLs.storageUrl}${state.data[3].thumbnail}",
                                title: state.data[3].categoryName,
                                value: state.data[3].totalStock,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is GetStockSummaryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GetStockSummaryFailed) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class RingkasanStokWidget extends StatelessWidget {
  final String title;
  final String value;
  final String imagePath;

  const RingkasanStokWidget({
    super.key,
    required this.title,
    required this.value,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardStatisticsBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          imagePath == "-"
              ? SizedBox(
                  height: 56,
                  width: 56,
                  child: CircleAvatar(backgroundColor: AppColors.textHint),
                )
              : ClipOval(
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 56,
                    width: 56,
                  ),
                ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "pcs",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ).copyWith(overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategorySales {
  CategorySales(this.category, this.total) {
    // Warna otomatis per kategori
    switch (category) {
      case 'Loster A':
        color = const Color(0xFF2A78D6);
        break;
      case 'Loster B':
        color = const Color(0xFFEB6834);
        break;
      case 'Batako':
        color = const Color(0xFF1BAF7A);
        break;
      default:
        color = const Color(0xFFEDA100);
    }
  }

  final String category;
  final double total;
  late final Color color;
}
