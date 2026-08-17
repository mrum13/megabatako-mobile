import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/account/presentation/pages/account_page.dart';
import 'package:megabatako/features/home/presentation/pages/home_page.dart';
import 'package:megabatako/features/image_picker/presentation/bloc/cubit/image_picker_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/blocs/cubit/navbar_cubit.dart';
import 'package:megabatako/features/order/presentation/pages/order_page.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/features/products/presentation/pages/products_page.dart';
import 'package:megabatako/routes/app_routes.dart';

class MainFrame extends StatelessWidget {
  const MainFrame({super.key});

  static const pages = [HomePage(), OrderPage(), ProductsPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavbarCubit, int>(
        builder: (context, index) {
          return IndexedStack(index: index, children: pages);
        },
      ),
      floatingActionButton: PopupMenuButton<String>(
        // Adjust the position offset if necessary
        offset: const Offset(0, -120),
        onSelected: (String value) async {
          // Handle your menu item selection here
          switch (value) {
            case 'option1':
              {
                context.read<ImagePickerCubit>().reset();
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.createProductPage,
                );

                if (result != null && result is Map) {
                  final title = result['title'];
                  final value = result['value'];

                  switch (title) {
                    case 'tambah_produk':
                      {
                        context.read<GetProductByCategoryCubit>().getData(productCategoryId: value);
                      }
                      break;
                    default:
                  }
                }
              }
              break;
            case 'option2':
              break;
            case 'option3':
              {
                Navigator.pushNamed(
                  context,
                  AppRoutes.createReportPage,
                );
              }
              break;
            default:
          }
        },
        // Customize the button appearance to match a Material FAB
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.add, size: 28, color: AppColors.surface),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'option1',
            child: ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Tambah Produk'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'option2',
            child: ListTile(
              leading: Icon(Icons.add_shopping_cart_sharp),
              title: Text('Buat Pesanan'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'option3',
            child: ListTile(
              leading: Icon(Icons.add_chart_rounded),
              title: Text('Buat Laporan'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomBar(),
    );
  }
}

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavbarCubit>().state;

    return BottomAppBar(
      notchMargin: 6,
      height: 64,
      color: AppColors.scaffoldBackground,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _navItem(
              title: 'Home',
              active: currentIndex == 0,
              icon: Icons.home,
              index: 0,
              context: context,
            ),
          ),
          Expanded(
            child: _navItem(
              title: 'Order',
              active: currentIndex == 1,
              icon: Icons.shopping_cart,
              index: 1,
              context: context,
            ),
          ),
          Expanded(
            child: _navItem(
              title: 'Produk',
              active: currentIndex == 2,
              icon: Icons.inventory,
              index: 2,
              context: context,
            ),
          ),
          Expanded(
            child: _navItem(
              title: 'Akun',
              active: currentIndex == 3,
              icon: Icons.account_circle_rounded,
              index: 3,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required String title,
    required bool active,
    required IconData icon,
    required int index,
    required BuildContext context,
  }) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          context.read<NavbarCubit>().setPage(index);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: active ? AppColors.surface : AppColors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
