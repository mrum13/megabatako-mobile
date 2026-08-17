import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/image_picker/presentation/bloc/cubit/image_picker_cubit.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/update_product_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? _selectedCategory;
  int? _selectedCategoryId;
  List<String> _categoryOptions = [];
  List<int> _categoryIds = [];

  String? imageFile;

  void showModalPhoto(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final cubit = context.read<ImagePickerCubit>();
                          Navigator.pop(context);
                          cubit.pickFromCamera();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            const SizedBox(height: 8),
                            Text("Ambil Foto"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final cubit = context.read<ImagePickerCubit>();
                          Navigator.pop(context);
                          cubit.pickFromGallery();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.photo),
                            const SizedBox(height: 8),
                            Text("Pilih Foto"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Edit Produk",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.scaffoldBackground),
        ),
      ),
      body: BlocBuilder<GetProductByCategoryCubit, GetProductByCategoryState>(
        builder: (context, state) {
          if (state is GetProductByCategorySuccess) {
            final product = state.data.firstWhere((p) => p.id == id);

            productNameController.text = product.name;
            priceController.text = product.price.toString();
            stockController.text = product.stock.toString();
            descriptionController.text = product.description;

            String? _selectedCategory = product.categoryName;
            int? _selectedCategoryId = product.productCategoryId;

            imageFile = "";

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Foto Produk"),
                      const SizedBox(height: 8),
                      BlocConsumer<ImagePickerCubit, ImagePickerState>(
                        listener: (context, state) {
                          if (state is ImagePickerSuccess) {
                            imageFile = state.image.path;
                          }
                        },
                        builder: (context, state) {
                          if (state is ImagePickerLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ImagePickerSuccess) {
                            return InkWell(
                              onTap: () {
                                showModalPhoto(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.file(state.image.file),
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () => showModalPhoto(context),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.network("${URLs.storageUrl}${product.thumbnail}"),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Kategori"),
                      const SizedBox(height: 8),
                      BlocBuilder<
                        GetProductCategoryCubit,
                        GetProductCategoryState
                      >(
                        builder: (context, state) {
                          if (state is GetProductCategorySuccess) {
                            List<String> data = state.data
                                .map((e) => e.name)
                                .toList();
                            List<int> dataIds = state.data
                                .map((e) => e.id)
                                .toList();
                            _categoryOptions.clear();
                            _categoryIds.clear();
                            _categoryOptions = data;
                            _categoryIds = dataIds;
                            return DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == "" || value.toString().isEmpty) {
                                  return "Pilih kategori terlebih dahulu !";
                                }
                                return null;
                              },
                              initialValue: _selectedCategory,
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
                              items: _categoryOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                  int index = _categoryOptions.indexWhere(
                                    (element) => element == newValue,
                                  );
                                  _selectedCategoryId = _categoryIds[index];
                                });
                                DMethod.log(
                                  "$_selectedCategory | $_selectedCategoryId",
                                );
                              },
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            );
                          } else if (state is GetProductCategoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is GetProductCategoryFailed) {
                            return Center(child: Text(state.message));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Nama Produk"),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(hint: Text("Contoh A-1")),
                        controller: productNameController,
                        validator: (value) {
                          if (value == "" || value.toString().isEmpty) {
                            return "Isi nama produk terlebih dahulu !";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Harga Jual"),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(hint: Text("Contoh 20000")),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == "" || value.toString().isEmpty) {
                            return "Isi harga terlebih dahulu !";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Stok"),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(hint: Text("Contoh 200")),
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == "" || value.toString().isEmpty) {
                            return "Isi stok terlebih dahulu !";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Deskripsi"),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hint: Text("Masukkan deskripsi produk"),
                        ),
                        controller: descriptionController,
                        validator: (value) {
                          if (value == "" || value.toString().isEmpty) {
                            return "Isi deskripsi terlebih dahulu !";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocConsumer<UpdateProductCubit, UpdateProductState>(
                        listener: (context, state) {
                          if (state is UpdateProductSuccess) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 100,
                                            color: AppColors.success,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Berhasil update produk",
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
                            ).then(
                              (value) {
                                context.read<GetProductByCategoryCubit>().getData(productCategoryId: product.productCategoryId);
                                Navigator.pop(context);
                              },
                            );
                          } else if (state is UpdateProductFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is UpdateProductLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Jika semua valid, lanjutkan proses
                                context.read<UpdateProductCubit>().updateData(
                                  data: StoreProductEntity(
                                    productCategoryId: _selectedCategoryId!,
                                    name: productNameController.text,
                                    price: priceController.text,
                                    thumbnail: imageFile!,
                                    stock: stockController.text,
                                    desc: descriptionController.text,
                                  ),
                                  idProduct: id
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save),
                                const SizedBox(width: 8),
                                Text("Simpan"),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Batal",
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
