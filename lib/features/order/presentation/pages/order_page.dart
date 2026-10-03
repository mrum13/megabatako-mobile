import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/core/utils/url_launcher_util.dart';
import 'package:megabatako/features/order/presentation/blocs/cubit/get_order_cubit.dart';
import 'package:megabatako/features/order/presentation/blocs/cubit/update_order_status_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/update_product_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Pesanan",
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.surface),
        ),
      ),
      body: ProdWidget(),
      // body: Center(
      //   child: Image.asset("assets/coming_soon.png", height: 200, width: 200,),
      // ),
    );
  }
}

class ProdWidget extends StatefulWidget {
  const ProdWidget({super.key});

  @override
  State<ProdWidget> createState() => _ProdWidgetState();
}

class _ProdWidgetState extends State<ProdWidget> {
  DateTime selectedDate = DateTime.now();
  String selectedDateApi = DateFormat(
    "yyyy-MM-dd",
  ).format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tanggal"),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<GetOrderCubit, GetOrderState>(
              builder: (context, state) {
                if (state is GetOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetOrderFailed) {
                  return Center(child: Text(state.message));
                } else if (state is GetOrderSuccess) {
                  return state.data.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/no_data.png",
                                fit: BoxFit.contain,
                                height: 150,
                                width: 150,
                              ),
                              Text(
                                "Data kosong",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () {
                                final order = state.data[index];

                                if (order.isFinish) {
                                  return;}
                                // sesuaikan aturannya:
                                if ((!order.pickupDelivery &&
                                    order.paymentSchema == "Lunas")) {
                                  return;
                                }

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return BlocConsumer<
                                      UpdateOrderStatusCubit,
                                      UpdateOrderStatusState
                                    >(
                                      listener: (ctx, s) {
                                        if (s is UpdateOrderStatusSuccess) {
                                          Navigator.pop(dialogContext);
                                          // refresh list order di sini
                                          context.read<GetOrderCubit>().getData(date: selectedDateApi);
                                        }
                                      },
                                      builder: (ctx, s) {
                                        if (s is UpdateOrderStatusLoading) {
                                          return const AlertDialog(
                                            content: SizedBox(
                                              height: 60,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          );
                                        }

                                        if (s is UpdateOrderStatusFailed) {
                                          return AlertDialog(
                                            title: Text(s.message),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  dialogContext,
                                                ),
                                                child: const Text("Tutup"),
                                              ),
                                            ],
                                          );
                                        }

                                        return AlertDialog(
                                          title: const Text(
                                            "Selesaikan pesanan?",
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dialogContext),
                                              child: const Text("Batal"),
                                            ),
                                            TextButton(
                                              onPressed: () => ctx
                                                  .read<
                                                    UpdateOrderStatusCubit
                                                  >()
                                                  .updateData(id: order.id),
                                              child: const Text("Ya"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.data[index].orderNumber,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            "dd MMM yyyy",
                                          ).format(state.data[index].date),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                      children: [
                                        ...state.data[index].items.map(
                                          (item) => Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .imagePreviewPage,
                                                      arguments: {
                                                        "source": "network",
                                                        "path":
                                                            "${URLs.storageUrl}${item.thumbnail}",
                                                      },
                                                    );
                                                  },
                                                  child: Image.network(
                                                    "${URLs.storageUrl}${item.thumbnail}",
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.name,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .textPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        indonesiaCurrency(
                                                          value: item.price
                                                              .toString(),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .primaryDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "x${item.quantity} pcs",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            String cleanedPhoneNumber = state
                                                .data[index]
                                                .customerNumber
                                                .replaceAll(' ', '')
                                                .replaceAll('-', '');
                                            openWhatsApp(
                                              phoneNumber: cleanedPhoneNumber,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/whatsapp.png",
                                                height: 24,
                                                width: 24,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${state.data[index].customerName} | ${state.data[index].customerNumber}",
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openMaps(
                                              state.data[index].customerAddress,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/map.png",
                                                height: 24,
                                                width: 24,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                state
                                                    .data[index]
                                                    .customerAddress,
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            children: [
                                              Chip(
                                                backgroundColor:
                                                    AppColors.success,
                                                label: Text(
                                                  state
                                                      .data[index]
                                                      .paymentMethod,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textOnPrimary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Chip(
                                                backgroundColor:
                                                    state
                                                            .data[index]
                                                            .paymentSchema ==
                                                        "Lunas"
                                                    ? AppColors.info
                                                    : AppColors.error,
                                                label: Text(
                                                  state.data[index].isFinish
                                                      ? "Lunas"
                                                      : (state
                                                                    .data[index]
                                                                    .paymentSchema ==
                                                                "Pembayaran Bertahap"
                                                            ? "DP ${indonesiaCurrency(value: state.data[index].downPayment.toString())}"
                                                            : state
                                                                  .data[index]
                                                                  .paymentSchema),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textOnPrimary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              state.data[index].pickupDelivery
                                                  ? Chip(
                                                      backgroundColor:
                                                          AppColors.warning,
                                                      label: Text(
                                                        state
                                                                .data[index]
                                                                .isFinish
                                                            ? "Sudah diantar"
                                                            : "Butuh Pengantaran",
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .textOnPrimary,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            indonesiaCurrency(
                                              value: state
                                                  .data[index]
                                                  .totalPrice
                                                  .toString(),
                                            ),
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemCount: state.data.length,
                        );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
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
      context.read<GetOrderCubit>().getData(date: selectedDateApi);
    });
  }
}
