import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool productSelected = false;
  int productId = 0;
  String imageSource = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Buat Laporan",
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
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(onPressed: () {}, child: Text("Simpan")),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Produk"),
            const SizedBox(height: 8),
            productSelected
                ? InkWell(
                    onTap: () async {
                      await chooseProduct(context);
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12)
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.09,
                        child: Image.network(
                          imageSource,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        chooseProduct(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.add_box_outlined, size: 56),
                            const SizedBox(height: 8),
                            Text("Pilih produk"),
                          ],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 24),
            Text("Jumlah Hasil Produksi (Pcs)"),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hint: Text("Contoh 200"),
                suffix: Text(
                  "Pcs",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              controller: quantityController,
              validator: (value) {
                if (value == "" || value.toString().isEmpty) {
                  return "Isi quantity terlebih dahulu !";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text("Catatan"),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hint: Text("Masukkan deskripsi produk"),
              ),
              controller: noteController,
              validator: (value) {
                if (value == "" || value.toString().isEmpty) {
                  return "Isi deskripsi terlebih dahulu !";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseProduct(BuildContext context) async {
    context.read<GetProductByCategoryCubit>().clear();
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.chooseProductReportPage,
    );
    
    if (result != null && result is Map) {
      setState(() {
        productSelected = true;
        imageSource = result['image'];
        productId = result['product_id'];
      });
    }
  }
}
