import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Akun",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<GetCurrentUserCubit, GetCurrentUserState>(
              builder: (context, state) {
                if (state is GetCurrentUserSuccess) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textHint),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 96,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.data.name,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          backgroundColor: AppColors.primary,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_pin,
                                color: AppColors.surface,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                state.data.role,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.surface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is GetCurrentUserFailed) {
                  return Center(child: Text(state.message));
                } else if (state is GetCurrentUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.categoryPage);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Row(
                children: [
                  Icon(Icons.file_copy),
                  const SizedBox(width: 16),
                  Text("Manajemen Kategori Produk"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Row(
                children: [
                  Icon(Icons.person),
                  const SizedBox(width: 16),
                  Text("Manajemen User"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage,
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: AppColors.error,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  const SizedBox(width: 4),
                  Text("Logout"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
