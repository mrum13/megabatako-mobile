import 'package:flutter/material.dart';
import 'package:megabatako/features/auth/presentation/pages/login_page.dart';
import 'package:megabatako/features/category/presentation/pages/category_page.dart';
import 'package:megabatako/features/employee/presentation/pages/form_employee_page.dart';
import 'package:megabatako/features/employee/presentation/pages/manage_employee_page.dart';
import 'package:megabatako/features/information/presentation/pages/information_page.dart';
import 'package:megabatako/features/main_frame/presentation/pages/main_frame.dart';
import 'package:megabatako/features/order/presentation/pages/choose_product_order_page.dart';
import 'package:megabatako/features/order/presentation/pages/create_order_page.dart';
import 'package:megabatako/features/products/presentation/pages/create_product_page.dart';
import 'package:megabatako/features/products/presentation/pages/detail_product_page.dart';
import 'package:megabatako/features/products/presentation/pages/update_product_page.dart';
import 'package:megabatako/features/report/presentation/pages/choose_product_page.dart';
import 'package:megabatako/features/report/presentation/pages/create_report_page.dart';
import 'package:megabatako/features/report/presentation/pages/detail_report_page.dart';
import 'package:megabatako/features/report/presentation/pages/report_page.dart';

class AppRoutes {
  // static const String splashPage = "/";
  static const String loginPage = "/login-page";
  static const String mainPage = "/main-frame";
  static const String createProductPage = "/create-product";
  static const String detailProductPage = "/detail-product";
  static const String updateProductPage = "/update-product";
  static const String createReportPage = "/create-report";
  static const String reportPage = "/report";
  static const String detailReportPage = "/detail-report";
  static const String chooseProductReportPage = "/choose-product-report";
  static const String categoryPage = "/category";
  static const String manageEmployeePage = "/manage-employee";
  static const String formEmployeePage = "/form-employee";
  static const String createOrderPage = "/create-order";
  static const String chooseProductOrderPage = "/choose-product-order";
  static const String informationPage = "/information";

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
      case manageEmployeePage:
        return MaterialPageRoute(
          builder: (context) => const ManageEmployeePage(),
          settings: settings,
        );
      case formEmployeePage:
        return MaterialPageRoute(
          builder: (context) => const FormEmployeePage(),
          settings: settings,
        );
      case reportPage:
        return MaterialPageRoute(
          builder: (context) => const ReportPage(),
          settings: settings,
        );
      case detailReportPage:
        return MaterialPageRoute(
          builder: (context) => const DetailReportPage(),
          settings: settings,
        );
      case createOrderPage:
        return MaterialPageRoute(
          builder: (context) => const CreateOrderPage(),
          settings: settings,
        );
      case chooseProductOrderPage:
        return MaterialPageRoute(
          builder: (context) => const ChooseProductOrderPage(),
          settings: settings,
        );
      case informationPage:
        return MaterialPageRoute(
          builder: (context) => const InformationPage(),
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
