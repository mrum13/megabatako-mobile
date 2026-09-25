import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/panjar/presentation/bloc/cubit/get_panjar_by_id_cubit.dart';

class DetailPanjarPage extends StatelessWidget {
  const DetailPanjarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        
    final accountState = context.read<GetCurrentUserCubit>().state;
    final bool isEmployee =
        accountState is GetCurrentUserSuccess &&
        accountState.data.role == 'employee';

    final name = args['name'];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Daftar Panjar $name",
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
        child: BlocBuilder<GetPanjarByIdCubit, GetPanjarByIdState>(
          builder: (context, state) {
            if (state is GetPanjarByIdLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetPanjarByIdSuccess) {
              if (state.data.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/no_data.png",
                        fit: BoxFit.contain,
                        height: 150,
                        width: 150,
                      ),
                      Text(
                        "Data kosong",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  DateTime date = DateTime.parse(state.data.items[index].date);
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textHint),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/panjar.png", height: 48, width: 48),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                indonesiaCurrency(
                                  value: state.data.items[index].quantity.toString(),
                                ),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat("dd MMMM yyyy").format(date),
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        state.data.items[index].isPaid == 1
                            ? Image.asset("assets/lunas.png", height: 45)
                            : isEmployee
                            ? const SizedBox.shrink()
                            : IconButton(
                                onPressed: () {},
                                icon: CircleAvatar(
                                  backgroundColor: AppColors.error,
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: state.data.items.length,
              );
            } else if (state is GetPanjarByIdFailed) {
              return Center(child: Text(state.message));
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
