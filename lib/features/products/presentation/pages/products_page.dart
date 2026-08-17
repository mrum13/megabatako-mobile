import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    String? selectedCategory;
    int? selectedCategoryId;
    List<String> categoryOptions = [];
    List<int> categoryIds = [];
    int idSelected = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Produk",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kategori Produk", style: GoogleFonts.inter(fontSize: 14)),
            const SizedBox(height: 8),
            BlocBuilder<GetProductCategoryCubit, GetProductCategoryState>(
              builder: (context, state) {
                if (state is GetProductCategorySuccess) {
                  List<String> data = state.data.map((e) => e.name).toList();
                  List<int> dataIds = state.data.map((e) => e.id).toList();
                  categoryOptions.clear();
                  categoryIds.clear();
                  categoryOptions = data;
                  categoryIds = dataIds;
                  return DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "" || value.toString().isEmpty) {
                        return "Pilih kategori terlebih dahulu !";
                      }
                      return null;
                    },
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      hintText: 'Pilih Kategori Produk',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.textHint,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    items: categoryOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                        int index = categoryOptions.indexWhere(
                          (element) => element == newValue,
                        );
                        selectedCategoryId = categoryIds[index];

                        context.read<GetProductByCategoryCubit>().getData(
                          productCategoryId: selectedCategoryId!,
                        );
                      });
                    },
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                    ),
                  );
                } else if (state is GetProductCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProductCategoryFailed) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<GetProductByCategoryCubit, GetProductByCategoryState>(
                builder: (context, state) {
                  if (state is GetProductByCategorySuccess) {
                    if (state.data.isEmpty) {
                      return const Center(
                        child: Text("Data Kosong"),
                      );
                    }
                    return GridView.count(
                      crossAxisCount: 2, // 2 kolom
                      shrinkWrap: true, // supaya ikut tinggi konten
                      physics:
                          const NeverScrollableScrollPhysics(), // biar nggak scroll sendiri
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75, // atur proporsi card
                      children: List.generate(state.data.length, (index) {
                        Color stockColor({required int stock}) {
                          if (stock >= 100) {
                            return AppColors.success;
                          } else if (stock >= 50 && stock < 100) {
                            return AppColors.warning;
                          } else {
                            return AppColors.error;
                          }
                        }

                        return InkWell(
                          onTap: () async {
                            idSelected = state.data[index].id;
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.detailProductPage,
                              arguments: idSelected,
                            );

                            if (result == true) {
                              context.read<GetProductByCategoryCubit>().getData(
                                productCategoryId: idSelected,
                              );
                            }

                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.textHint),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1.09,
                                    child: Image.network(
                                      "${URLs.storageUrl}${state.data[index].thumbnail}",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.data[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              indonesiaCurrency(
                                                value: state.data[index].price
                                                    .toString(),
                                              ),
                                              style: GoogleFonts.inter(
                                                color: AppColors.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.inventory_rounded,
                                                  size: 16,
                                                  color: stockColor(
                                                    stock: int.parse(
                                                      state.data[index].stock
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  state.data[index].stock
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  } else if (state is GetProductByCategoryFailed) {
                    return Center(child: Text(state.message));
                  } else if (state is GetProductByCategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(
                      child: Text("Silahkan pilih kategori produk"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
