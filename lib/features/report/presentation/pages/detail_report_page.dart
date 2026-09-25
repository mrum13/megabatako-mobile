import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/api/urls.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/formatter.dart';
import 'package:megabatako/features/panjar/presentation/bloc/cubit/get_panjar_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_report_date_by_id_cubit.dart';
import 'package:megabatako/features/report/presentation/bloc/cubit/get_summary_withdraw_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';

class DetailReportPage extends StatefulWidget {
  const DetailReportPage({super.key});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  late int idEmployee;

  Map<DateTime, bool> _markedDates =
      {}; // key: tanggal (normalized), value: is_paid

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool? _getPaidStatus(DateTime date) {
    final normalized = _normalize(date);
    if (_markedDates.containsKey(normalized)) {
      return _markedDates[normalized];
    }
    return null; // null = tidak ada mark sama sekali
  }

  List<String> eventsForDate(DateTime date) {
    final status = _getPaidStatus(date);
    if (status == null) return [];
    return [status ? "paid" : "not_paid"];
  }

  Widget buildEventMarkers(
    BuildContext context,
    CalendarDayDetails<String> day,
  ) {
    if (day.events.isEmpty) return const SizedBox.shrink();

    final isPaid = day.events.first == "paid";

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: day.isSelected
              ? Colors.white
              : (isPaid ? Colors.green : Colors.indigo),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
      bottomNavigationBar:
          BlocBuilder<GetSummaryWithdrawCubit, GetSummaryWithdrawState>(
            builder: (context, state) {
              if (state is GetSummaryWithdrawLoading) {
                return BottomAppBar(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else if (state is GetSummaryWithdrawSuccess) {
                return state.data.data.isEmpty
                    ? SizedBox.shrink()
                    : BottomAppBar(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<GetPanjarByIdCubit>().getData(
                                userId: idEmployee,
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.summaryWithdrawPage,
                                arguments: {
                                  "user_id": idEmployee,
                                  "user_name": name,
                                  "total": state.data.totalEmployeeRate
                                      .toString(),
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                            ),
                            child: Text("Withdraw"),
                          ),
                        ),
                      );
              } else if (state is GetSummaryWithdrawFailed) {
                return BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text(state.message)),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetReportDateByIdCubit, GetReportDateByIdState>(
              builder: (context, state) {
                if (state is GetReportDateByIdLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GetReportDateByIdSuccess) {
                  for (final item in state.data) {
                    final date = DateTime.parse(item.date);
                    final isPaid = item.isPaid == 1;
                    _markedDates[_normalize(date)] = isPaid;
                  }

                  return SizedBox(
                    height: 300,
                    child: CalendarCarousel<String>.month(
                      selectedDate: selectedDate,
                      focusedDate: focusedDate,
                      locale: Locale('id', 'ID'),
                      onDateSelected: (DateTime date, List<String> events) {
                        setState(() {
                          selectedDate = date;
                          context.read<GetReportByIdCubit>().getData(
                            idEmployee: idEmployee,
                            date: DateFormat("yyyy-MM-dd").format(selectedDate),
                          );
                        });
                      },
                      onPageChanged: (DateTime pageAnchor) {
                        setState(() => focusedDate = pageAnchor);
                      },
                      eventsForDate: eventsForDate,
                      markerBuilder: buildEventMarkers,
                      theme: const CalendarCarouselThemeData(
                        selected: CalendarDayStyle(
                          backgroundColor: AppColors.primary,
                          textStyle: TextStyle(color: AppColors.textOnPrimary),
                        ),
                        today: CalendarDayStyle(
                          backgroundColor: AppColors.textOnPrimary,
                          textStyle: TextStyle(color: AppColors.textPrimary),
                        ),
                        marker: CalendarMarkerStyle(
                          color: Colors.deepOrange,
                          maxVisible: 1,
                        ),
                        weekend: CalendarDayStyle(
                          textStyle: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  );
                } else if (state is GetReportDateByIdFailed) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center();
                }
              },
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
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(8),
                                      child: Image.network(
                                        "${URLs.storageUrl}${state.data[index].productThumbnail}",
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.description,
                                                color: AppColors.warning,
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
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.monetization_on,
                                                color: AppColors.success,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                " : ${indonesiaCurrency(value: state.data[index].totalEmployeeRateItem.toString())}",
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
                                      padding:
                                          const EdgeInsetsGeometry.symmetric(
                                            horizontal: 8,
                                          ),
                                      child: state.data[index].isPaid == 0
                                          ? Text(
                                              "+ ${state.data[index].quantity}",
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: AppColors.primaryDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  "+ ${state.data[index].quantity}",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color:
                                                        AppColors.primaryDark,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Image.asset("assets/lunas.png", height: 45)
                                              ],
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
    context.read<GetReportByIdCubit>().getData(
      idEmployee: idEmployee,
      date: DateFormat("yyyy-MM-dd").format(args),
    );
  }
}
