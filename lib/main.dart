import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_theme.dart';
import 'package:megabatako/di/injection.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/auth/presentation/blocs/cubit/sign_in_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/delete_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/store_product_category_cubit.dart';
import 'package:megabatako/features/image_picker/presentation/bloc/cubit/image_picker_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/blocs/cubit/navbar_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/pages/main_frame.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/delete_product_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/store_product_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/update_product_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  await URLs.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<NavbarCubit>()),
        BlocProvider(create: (context) => locator<SignInCubit>()),
        BlocProvider(create: (context) => locator<GetCurrentUserCubit>()),
        BlocProvider(create: (context) => locator<StoreProductCategoryCubit>()),
        BlocProvider(create: (context) => locator<GetProductCategoryCubit>()),
        BlocProvider(create: (context) => locator<DeleteProductCategoryCubit>()),
        BlocProvider(create: (context) => locator<ImagePickerCubit>()),
        BlocProvider(create: (context) => locator<StoreProductCubit>()),
        BlocProvider(create: (context) => locator<GetProductByCategoryCubit>()),
        BlocProvider(create: (context) => locator<DeleteProductCubit>()),
        BlocProvider(create: (context) => locator<UpdateProductCubit>()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: MainFrame(),
        initialRoute: AppRoutes.loginPage,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
