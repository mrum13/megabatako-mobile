import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/screen_tap.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/store_report_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool productSelected = false;
  int productId = 0;
  String imageSource = "";

  String? _selectedEmployeeName;
  int? selectedEmployeeId;
  List<String> employeeNameOptions = [];
  List<int> employeeIdOptions = [];

  @override
  Widget build(BuildContext context) {
    final accountState = context.read<GetCurrentUserCubit>().state;
    final bool isEmployee=
        accountState is GetCurrentUserSuccess &&
        accountState.data.role == 'employee';
    final int currentUserId = accountState is GetCurrentUserSuccess ? accountState.data.id : 0;
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
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<StoreReportCubit, StoreReportState>(
            listener: (context, state) {
              if (state is StoreReportFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is StoreReportSuccess) {
                showSuccessDialog(context, "Berhasil buat laporan");
              }
            },
            builder: (context, state) {
              if (state is StoreReportLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  if (isEmployee) {
                    selectedEmployeeId = currentUserId;
                  }
                  if (formKey.currentState!.validate() &&
                      selectedEmployeeId != null &&
                      productId != 0) {
                    context.read<StoreReportCubit>().storeData(
                      data: StoreReportEntity(
                        userId: selectedEmployeeId!,
                        productId: productId,
                        quantity: int.parse(quantityController.text),
                        note: noteController.text,
                        date: DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(DateTime.now()),
                      ),
                    );
                  }
                },
                child: Text("Simpan"),
              );
            },
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: GestureDetector(
          onTap: () => screenTap(),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: SingleChildScrollView(
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
                              Radius.circular(12),
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
                  Visibility(
                    visible: !isEmployee,
                    child:
                        BlocBuilder<GetListEmployeeCubit, GetListEmployeeState>(
                          builder: (context, state) {
                            if (state is GetListEmployeeLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is GetListEmployeeSuccess) {
                              List<String> data = state.data
                                  .map((e) => e.name)
                                  .toList();
                              List<int> dataIds = state.data
                                  .map((e) => e.id)
                                  .toList();
                              employeeNameOptions.clear();
                              employeeIdOptions.clear();
                              employeeNameOptions = data;
                              employeeIdOptions = dataIds;
          
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  Text("Pegawai"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    validator: (value) {
                                      if (value == "" ||
                                          value.toString().isEmpty) {
                                        return "Pilih pegawai terlebih dahulu !";
                                      }
                                      return null;
                                    },
                                    initialValue: _selectedEmployeeName,
                                    decoration: InputDecoration(
                                      hintText: 'Pilih pegawai',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textHint,
                                      ),
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
                                    items: employeeNameOptions.map((
                                      String value,
                                    ) {
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
                                        int index = employeeNameOptions
                                            .indexWhere(
                                              (element) => element == newValue,
                                            );
                                        selectedEmployeeId =
                                            employeeIdOptions[index];
                                      });
                                    },
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text("Jumlah Hasil Produksi (Pcs)"),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
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
          ),
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

  void showSuccessDialog(BuildContext context, String value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogSuccess(value: value);
      },
    ).then((value) {
      // context.read<GetListEmployeeCubit>().getData();
      Navigator.pop(context);
    });
  }
}
