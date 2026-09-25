import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/auth/presentation/blocs/cubit/sign_in_cubit.dart';
import 'package:megabatako/features/auth/presentation/pages/login_page.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/home/presentation/blocs/cubit/get_stock_summary_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/blocs/cubit/navbar_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SignInCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    void afterSignIn(BuildContext context) {
      context.read<GetCurrentUserCubit>().getCurrentUser();
      context.read<GetProductCategoryCubit>().getData();
      context.read<GetListEmployeeCubit>().getData();
      context.read<GetStockSummaryCubit>().getData();
      context.read<NavbarCubit>().setPage(0);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignInCubit, SignInState>(
            listener: (context, state) {
              DMethod.log("State $state");
              if (state is SignInSuccess) {
                afterSignIn(context);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage,
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          BlocListener<GetCurrentUserCubit, GetCurrentUserState>(
            listener: (context, state) {
              if (state is GetCurrentUserSuccess) {
                // context.read<SignInCubit>().setInit();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.mainPage,
                  (Route<dynamic> route) => false,
                );
              } else if (state is GetCurrentUserFailed) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage,
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/logo.png", height: 94, width: 94),
              const SizedBox(height: 24),
              Text(
                "Mega Batako",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(color: AppColors.background),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
