import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/delete_product_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments as int;

    DMethod.log("ID BUILD DETAIL PRODUCT = $id");

    Color stockColor({required int stock}) {
      if (stock >= 100) {
        return AppColors.success;
      } else if (stock >= 50 && stock < 100) {
        return AppColors.warning;
      } else {
        return AppColors.error;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Detail Produk",
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
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateProductPage,
                    arguments: id,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 22),
                    const SizedBox(width: 4),
                    Text("Update Produk"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              BlocConsumer<DeleteProductCubit, DeleteProductState>(
                listener: (context, state) {
                  if (state is DeleteProductSuccess) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 100,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Berhasil hapus produk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        52,
                                      ),
                                    ),
                                    child: Text("Kembali"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).then((value) => Navigator.pop(context, true));
                  } else if (state is DeleteProductFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is DeleteProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Produk'),
                          content: const Text(
                            'Yakin ingin menghapus produk ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<DeleteProductCubit>().deleteData(
                                  idProduct: id,
                                );
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.error,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 22),
                        const SizedBox(width: 4),
                        Text(
                          "Hapus Produk",
                          style: TextStyle(color: AppColors.textOnPrimary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child:
            BlocBuilder<GetProductByCategoryCubit, GetProductByCategoryState>(
              builder: (context, state) {
                if (state is GetProductByCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProductByCategorySuccess) {
                  final product = state.data.firstWhere((p) => p.id == id);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: Image.network(
                            "${URLs.storageUrl}${product.thumbnail}",
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Nama Produk : ",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Harga : ",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              indonesiaCurrency(
                                value: product.price.toString(),
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Stock : ",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Row(
                              children: [
                                Text(
                                  product.stock.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.darkSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.inventory_rounded,
                                  size: 16,
                                  color: stockColor(
                                    stock: int.parse(product.stock.toString()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Deskripsi : ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.darkSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is GetProductByCategoryFailed) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
      ),
    );
  }
}
