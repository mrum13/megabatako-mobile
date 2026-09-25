import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/features/panjar/presentation/bloc/cubit/get_panjar_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_date_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_summary_withdraw_cubit.dart';
import 'package:megabatako/features/withdraw/domain/entities/store_withdraw_entity.dart';
import 'package:megabatako/features/withdraw/presentation/bloc/cubit/store_withdraw_cubit.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class SummaryWithdrawPage extends StatelessWidget {
  const SummaryWithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    int idEmployee = args['user_id'];
    final name = args['user_name'];
    final total = args['total'];

    num totalPanjar = 0;
    num totalFinal = 0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Withdraw $name",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.scaffoldBackground),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subtotal : ${indonesiaCurrency(value: total)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<GetPanjarByIdCubit, GetPanjarByIdState>(
                builder: (context, state) {
                  if (state is GetPanjarByIdSuccess) {
                    totalPanjar = state.data.totalQuantity;
                    totalFinal = num.parse(total) - totalPanjar;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Panjar : ${indonesiaCurrency(value: totalPanjar.toString())}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Total : ${indonesiaCurrency(value: totalFinal.toString())}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),

              const SizedBox(height: 24),
              BlocConsumer<StoreWithdrawCubit, StoreWithdrawState>(
                listener: (context, state) {
                  if (state is StoreWithdrawSuccess) {
                    showSuccessDialog(context, "Berhasil melakukan withdraw", idEmployee);
                  } else if (state is StoreWithdrawFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StoreWithdrawLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Batal",
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<StoreWithdrawCubit>().storeData(
                                    data: StoreWithdrawEntity(
                                      userId: idEmployee,
                                      subtotal: total,
                                      panjar: totalPanjar.toString(),
                                      total: totalFinal.toString(),
                                      dateTime: DateTime.now().toString(),
                                    ),
                                  );
                                },
                                child: Text("Simpan"),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            title: Text("Simpan withdraw ?"),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: Text("Simpan"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GetSummaryWithdrawCubit, GetSummaryWithdrawState>(
                builder: (context, state) {
                  if (state is GetSummaryWithdrawLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetSummaryWithdrawSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.textHint),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.network(
                                  "${URLs.storageUrl}${state.data.data[index].productThumbnail}",
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.data.data[index].productName,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${indonesiaCurrency(value: state.data.data[index].employeeRate.toString())} x ${state.data.data[index].totalQuantity}pcs",
                                      style: TextStyle(
                                        color: AppColors.darkSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      indonesiaCurrency(
                                        value: state
                                            .data
                                            .data[index]
                                            .subTotalEmployeeRate
                                            .toString(),
                                      ),
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: state.data.data.length,
                    );
                  } else if (state is GetSummaryWithdrawFailed) {
                    return Center(child: Text(state.message));
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context, String value, int idEmployee) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogSuccess(value: value);
      },
    ).then((value) {
      context.read<GetReportDateByIdCubit>().getData(idEmployee: idEmployee);
      Navigator.pop(context);
    });
  }
}
