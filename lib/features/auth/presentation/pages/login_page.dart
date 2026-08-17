import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/auth/presentation/blocs/cubit/sign_in_cubit.dart';
import 'package:megabatako/features/auth/presentation/widgets/text_form_field_bordered.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void afterSignIn(BuildContext context) {
      context.read<GetCurrentUserCubit>().getCurrentUser();
      context.read<GetProductCategoryCubit>().getData();
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png", height: 94, width: 94,),
                  const SizedBox(height: 24),
                  Text(
                    "Mega Batako",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to manage your operations",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),),
                          const SizedBox(height: 6),
                          TextFormFieldBordered(
                            obscureText: false,
                            controller: usernameController,
                            hint: "Masukkan username",
                            validator: (value) {
                              if (value == "" || value.toString().isEmpty) {
                                return "Username tidak boleh kosong !";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text("Password", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormFieldBordered(
                            obscureText: true,
                            controller: passwordController,
                            hint: "Masukkan password",
                            validator: (value) {
                              if (value == "" || value.toString().isEmpty) {
                                return "Password tidak boleh kosong !";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<SignInCubit, SignInState>(
                            listener: (context, state) {
                              if (state is SignInSuccess) {
                                afterSignIn(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                      AppRoutes.mainPage,
                                      (Route<dynamic> route) => false,
                                    );
                              } else if (state is SignInFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error,));
                              }
                            },
                            builder: (context, state) {
                              if (state is SignInLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    // Jika semua valid, lanjutkan proses
                                    context.read<SignInCubit>().signin(email: usernameController.text, password: passwordController.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 54),
                                  backgroundColor: AppColors.primary,
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.scaffoldBackground,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
