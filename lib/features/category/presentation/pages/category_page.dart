import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/auth/presentation/widgets/text_form_field_bordered.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/delete_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/store_product_category_cubit.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "List Kategori",
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
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Kategori",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            TextFormFieldBordered(
                              obscureText: false,
                              controller: nameController,
                              hint: "Masukkan nama kategori",
                              validator: (value) {
                                if (value == "" || value.toString().isEmpty) {
                                  return "Kategori tidak boleh kosong !";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<StoreProductCategoryCubit, StoreProductCategoryState>(
                              builder: (context, state) {
                                if (state is StoreProductCategoryLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context
                                          .read<StoreProductCategoryCubit>()
                                          .storeData(name: nameController.text);

                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      52,
                                    ),
                                  ),
                                  child: Text("Simpan"),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text("Tambah Data"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<
              DeleteProductCategoryCubit,
              DeleteProductCategoryState
            >(
              listener: (context, state) {
                if (state is DeleteProductCategoryFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else if (state is DeleteProductCategorySuccess) {
                  showSuccessDialog(context, "Berhasil hapus kategori");
                }
              },
            ),
            BlocListener<StoreProductCategoryCubit,StoreProductCategoryState>(
              listener: (context, state) {
                if (state is StoreProductCategorySuccess) {
                  showSuccessDialog(context, "Berhasil tambah kategori");
                } else if (state is StoreProductCategoryFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            )
          ],
          child: BlocBuilder<GetProductCategoryCubit, GetProductCategoryState>(
            builder: (context, state) {
              if (state is GetProductCategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetProductCategorySuccess) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.data.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text(state.data[index].name)),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: CircleAvatar(
                                          child: Icon(Icons.edit),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Hapus Kategori',
                                              ),
                                              content: const Text(
                                                'Yakin ingin menghapus kategori ini?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    context
                                                        .read<
                                                          DeleteProductCategoryCubit
                                                        >()
                                                        .deleteData(
                                                          idCategory: state
                                                              .data[index]
                                                              .id,
                                                        );
                                                  },
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      color: AppColors.error,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
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
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is GetProductCategoryFailed) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context, String value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 100,
                  color: AppColors.success,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
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
        );
      },
    ).then((value) {
      context.read<GetProductCategoryCubit>().getData();
    });
  }
}
