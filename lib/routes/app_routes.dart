import 'package:flutter/material.dart';
import 'package:megabatako/features/auth/presentation/pages/login_page.dart';
import 'package:megabatako/features/category/presentation/pages/category_page.dart';
import 'package:megabatako/features/main_frame/presentation/pages/main_frame.dart';
import 'package:megabatako/features/products/presentation/pages/create_product_page.dart';
import 'package:megabatako/features/products/presentation/pages/detail_product_page.dart';
import 'package:megabatako/features/products/presentation/pages/update_product_page.dart';
import 'package:megabatako/features/reports/presentation/pages/choose_product_page.dart';
import 'package:megabatako/features/reports/presentation/pages/create_report_page.dart';

class AppRoutes {
  // static const String splashPage = "/";
  static const String loginPage = "/login-page";
  static const String mainPage = "/main-frame";
  static const String createProductPage = "/create-product";
  static const String detailProductPage = "/detail-product";
  static const String updateProductPage = "/update-product";
  static const String createReportPage = "/create-report";
  static const String chooseProductReportPage = "/choose-product-report";
  static const String categoryPage = "/category";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Normalisasi URL
    final uri = Uri.tryParse(settings.name ?? '');
    final path = uri?.path ?? settings.name;

    switch (path) {
      case loginPage:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case mainPage:
        return MaterialPageRoute(
          builder: (context) => const MainFrame(),
          settings: settings,
        );
      case createProductPage:
        return MaterialPageRoute(
          builder: (context) => const CreateProductPage(),
        );
      case detailProductPage:
        return MaterialPageRoute(
          builder: (context) => const DetailProductPage(),
          settings: settings,
        );
      case updateProductPage:
        return MaterialPageRoute(
          builder: (context) => const UpdateProductPage(),
          settings: settings,
        );
      case createReportPage:
        return MaterialPageRoute(
          builder: (context) => const CreateReportPage(),
          settings: settings,
        );
      case chooseProductReportPage:
        return MaterialPageRoute(
          builder: (context) => const ChooseProductPage(),
          settings: settings,
        );
      case categoryPage:
        return MaterialPageRoute(
          builder: (context) => const CategoryPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('Halaman yang dituju tidak ada = $path')),
          ),
        );
    }
  }
}
