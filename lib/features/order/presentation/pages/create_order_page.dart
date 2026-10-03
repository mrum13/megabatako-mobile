import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/core/utils/screen_tap.dart';
import 'package:megabatako/features/order/domain/entities/product_items_store_entity.dart';
import 'package:megabatako/features/order/domain/entities/store_order_entity.dart';
import 'package:megabatako/features/order/presentation/blocs/cubit/get_order_cubit.dart';
import 'package:megabatako/features/order/presentation/blocs/cubit/store_order_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  DateTime selectedDate = DateTime.now();
  String selectedDateApi = DateFormat(
    "yyyy-MM-dd HH:mm:ss",
  ).format(DateTime.now());
  String? selectedPaymentMethod;
  List<String> paymentMethodOptions = ["Tunai", "Transfer"];
  String? selectedPaymentScheme;
  List<String> paymentSchemeOptions = [
    "Lunas",
    "Pembayaran Bertahap",
    "Bayar ditujuan pengantaran",
  ];
  bool isDelivery = false;
  TextEditingController paymentSchemeController = TextEditingController(
    text: "0",
  );
  TextEditingController locationController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();

  List<ProductItemsStoreEntity> productData = [];

  final Map<int, TextEditingController> _qtyControllers = {};

  TextEditingController _controllerFor(ProductItemsStoreEntity product) {
    return _qtyControllers.putIfAbsent(
      product.idProduct,
      () => TextEditingController(text: '1'), // jumlah awal 1
    );
  }

  void _addProduct(ProductItemsStoreEntity product) {
    setState(() {
      productData.add(product);
      _qtyControllers[product.idProduct] = TextEditingController(text: '1');
    });
  }

  @override
  void dispose() {
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get totalHarga {
    return productData.fold<double>(0, (sum, p) {
      final qty = int.tryParse(_qtyControllers[p.idProduct]?.text ?? '') ?? 0;
      final price = int.tryParse(p.productPrice.toString()) ?? 0;
      return sum + (price * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Buat Pesanan",
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.surface),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total : ${indonesiaCurrency(value: totalHarga.toString())}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              BlocConsumer<StoreOrderCubit, StoreOrderState>(
                listener: (context, state) {
                  if (state is StoreOrderSuccess) {
                    showSuccessDialog(context, "Berhasil buat pesanan");
                  } else if (state is StoreOrderFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StoreOrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final List<StoreOrderItemEntity> items = productData.map((
                        p,
                      ) {
                        final qty =
                            int.tryParse(
                              _qtyControllers[p.idProduct]?.text ?? '',
                            ) ??
                            0;
                        return StoreOrderItemEntity(
                          productId: p.idProduct,
                          productQuantity: qty,
                        );
                      }).toList();

                      context.read<StoreOrderCubit>().storeData(
                        data: StoreOrderEntity(
                          customerName: customerNameController.text,
                          customerPhone: customerPhoneController.text,
                          customerAddress: locationController.text,
                          paymentMethod: selectedPaymentMethod!,
                          paymentScheme: selectedPaymentScheme!,
                          downPayment: paymentSchemeController.text,
                          pickupDelivery: isDelivery,
                          date: selectedDateApi,
                          isFinish:
                              selectedPaymentScheme == "Lunas" && !isDelivery
                              ? true
                              : false,
                          orderItem: items,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: Text("Simpan"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => screenTap(),
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textHint),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Detail Produk",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      productData.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.textHint,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.imagePreviewPage,
                                                arguments: {
                                                  "source": "network",
                                                  "path": productData[index]
                                                      .productImage,
                                                },
                                              );
                                            },
                                            child: Image.network(
                                              productData[index].productImage,
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productData[index]
                                                      .productName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  indonesiaCurrency(
                                                    value: productData[index]
                                                        .productPrice,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.primaryDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 76,
                                            child: TextField(
                                              controller: _controllerFor(
                                                productData[index],
                                              ),
                                              onChanged: (_) => setState(() {}),
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 4,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color: AppColors
                                                                .textHint,
                                                            width: 1.0,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              final removed =
                                                  productData[index];
                                              setState(() {
                                                productData.removeAt(index);
                                              });
                                              _qtyControllers
                                                  .remove(removed.idProduct)
                                                  ?.dispose();
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemCount: productData.length,
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.chooseProductOrderPage,
                                    );

                                    if (result != null &&
                                        result is ProductItemsStoreEntity) {
                                      final alreadyAdded = productData.any(
                                        (item) =>
                                            item.idProduct == result.idProduct,
                                      );
                                      if (alreadyAdded) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Produk sudah dipilih",
                                            ),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _addProduct(result);
                                        });
                                      }
                                    }
                                  },
                                  child: Text("Tambah produk"),
                                ),
                              ],
                            )
                          : Center(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.transparent),
                                ),
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.chooseProductOrderPage,
                                  );

                                  if (result != null &&
                                      result is ProductItemsStoreEntity) {
                                    setState(() {
                                      _addProduct(result);
                                    });
                                  }
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textHint),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.wallet, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            "Pembayaran & Pengantaran",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedPaymentMethod,
                        decoration: InputDecoration(
                          hintText: 'Pilih metode pembayaran',
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
                        items: paymentMethodOptions.map((String value) {
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
                            selectedPaymentMethod = newValue;
                          });
                        },
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Skema Pembayaran",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedPaymentScheme,
                        decoration: InputDecoration(
                          hintText: 'Pilih skema pembayaran',
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
                        items: paymentSchemeOptions.map((String value) {
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
                            selectedPaymentScheme = newValue;
                          });
                        },
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                        ),
                      ),
                      Visibility(
                        visible: selectedPaymentScheme != "Pembayaran Bertahap"
                            ? false
                            : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Uang Muka (DP)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hint: Text("Masukkan DP"),
                                prefix: Text(
                                  "Rp.",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              controller: paymentSchemeController,
                              validator: (value) {
                                if (selectedPaymentScheme != "Lunas") {
                                  if (value == "" || value.toString().isEmpty) {
                                    return "Isi quantity terlebih dahulu !";
                                  }
                                  return null;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            color: AppColors.textSecondary,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pengantaran",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Kirim ke alamat pelanggan",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isDelivery,
                            onChanged: (value) {
                              setState(() {
                                isDelivery = !isDelivery;
                              });
                            },
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textHint),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.person, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            "Informasi Customer",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        "Nama Customer",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hint: Text("Masukkan Nama"),
                        ),
                        controller: customerNameController,
                        validator: (value) {
                          if (isDelivery) {
                            if (value == "" || value.toString().isEmpty) {
                              return "Isi nama terlebih dahulu !";
                            }
                            return null;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No HP Customer",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hint: Text("Masukkan No HP"),
                        ),
                        controller: customerPhoneController,
                        validator: (value) {
                          if (isDelivery) {
                            if (value == "" || value.toString().isEmpty) {
                              return "Isi No HP terlebih dahulu !";
                            }
                            return null;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Alamat Customer",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hint: Text("Masukkan Alamat"),
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                        ),
                        controller: locationController,
                        validator: (value) {
                          if (isDelivery) {
                            if (value == "" || value.toString().isEmpty) {
                              return "Isi alamat terlebih dahulu !";
                            }
                            return null;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tanggal Order",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          _selectDate(
                            context,
                            selectedDate,
                            onSelectionStartDatePicker,
                            false,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            DateFormat("dd MMMM yyyy").format(selectedDate),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        return DialogSuccess(value: value);
      },
    ).then((value) {
      context.read<GetOrderCubit>().getData(
        date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      );
      Navigator.pop(context);
    });
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime selectedDay,
    void Function(DateTime args) onSelectionDatePicker,
    bool isEndDate,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // warna header & tanggal terpilih
              onPrimary: Colors.white, // warna teks pada header
              onSurface: Colors.black, // warna teks tanggal
            ),
            dialogBackgroundColor: Colors.white, // warna background dialog
          ),
          child: child!,
        );
      },
      firstDate: DateTime(2015),
      lastDate: DateTime(2040),
    );

    onSelectionDatePicker(pickedDate ?? selectedDay);
  }

  void onSelectionStartDatePicker(DateTime args) {
    setState(() {
      selectedDate = args;
      selectedDateApi = DateFormat("yyyy-MM-dd").format(args);
    });
  }
}
