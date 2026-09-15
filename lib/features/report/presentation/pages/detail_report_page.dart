import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_by_id_cubit.dart';

class DetailReportPage extends StatefulWidget {
  const DetailReportPage({super.key});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  DateTime selectedDate = DateTime.now();
  late int idEmployee; 
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    idEmployee = args['id'];
    final name = args['name'];
    
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Laporan Kerja $name",
          style: GoogleFonts.inter(color: AppColors.surface, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.scaffoldBackground),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Tanggal"),
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(DateFormat("dd MMMM yyyy").format(selectedDate), style: TextStyle(color: AppColors.textPrimary),),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<GetReportByIdCubit, GetReportByIdState>(
                builder: (context, state) {
                  if (state is GetReportByIdLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetReportByIdSuccess) {
                    return state.data.isEmpty
                    ? Center(child: Text("Data Kosong"),)
                    : ListView.separated(
                      itemBuilder: (context, index) {
                        DateTime date = DateTime.parse(state.data[index].date);
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.network(
                                  "${URLs.storageUrl}${state.data[index].productThumbnail}",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: AppColors.error,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          " : ${state.data[index].productName}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Row(
                                    //   children: [
                                    //     Icon(Icons.calendar_month,color: AppColors.success, size: 16),
                                    //     const SizedBox(width: 4),
                                    //     Text(
                                    //       " : ${DateFormat('dd MMMM yyyy').format(date)}",
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: AppColors.textPrimary,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          color: AppColors.warning,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          " : ${DateFormat('HH:mm:ss').format(date)}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: AppColors.success,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          " : ${state.data[index].note}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsGeometry.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "+ ${state.data[index].quantity}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 16);
                      },
                      itemCount: state.data.length,
                    );
                  } else if (state is GetReportByIdFailed) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
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
    });
    context.read<GetReportByIdCubit>().getData(idEmployee: idEmployee, date: DateFormat("yyyy-MM-dd").format(args));
  }
}
