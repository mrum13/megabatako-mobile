import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/employee/domain/entities/employee_entity.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_date_by_id_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountState = context.read<GetCurrentUserCubit>().state;

    final bool isSuperAdmin =
        accountState is GetCurrentUserSuccess &&
        accountState.data.role == 'superadmin';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Laporan Kerja",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih pegawai untuk melihat laporan kerja",
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<GetListEmployeeCubit, GetListEmployeeState>(
                builder: (context, state) {
                  if (state is GetListEmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetListEmployeeSuccess) {
                    // Filter data sesuai role
                    final List<EmployeeEntity> filteredData = isSuperAdmin
                        ? state.data // superadmin lihat semua data
                        : state.data.where((user) => user.role != 'owner').toList();
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<GetReportByIdCubit>().getData(
                              idEmployee: filteredData[index].id,
                              date: DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.now()),
                            );
                            context.read<GetReportDateByIdCubit>().getData(idEmployee: filteredData[index].id);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detailReportPage,
                              arguments: {
                                "id": filteredData[index].id,
                                "name": filteredData[index].name,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.account_circle, size: 56),
                              title: Text(filteredData[index].name),
                              subtitle: Text(filteredData[index].role),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: filteredData.length,
                    );
                  } else if (state is GetListEmployeeFailed) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
