import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/panjar/presentation/bloc/cubit/get_panjar_by_id_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class PanjarPage extends StatelessWidget {
  const PanjarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Daftar Panjar",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih pegawai untuk melihat panjar",
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<GetListEmployeeCubit, GetListEmployeeState>(
                builder: (context, state) {
                  if (state is GetListEmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetListEmployeeSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<GetPanjarByIdCubit>().getData(userId: state.data[index].id);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detailPanjar,
                              arguments: {
                                "name": state.data[index].name,
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
                              title: Text(state.data[index].name),
                              subtitle: Text(state.data[index].role),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: state.data.length,
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
