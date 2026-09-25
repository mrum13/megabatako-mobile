import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/core/utils/screen_tap.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/panjar/domain/entities/store_panjar_entity.dart';
import 'package:megabatako/features/panjar/presentation/bloc/cubit/store_panjar_cubit.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class CreatePanjarPage extends StatefulWidget {
  const CreatePanjarPage({super.key});

  @override
  State<CreatePanjarPage> createState() => _CreatePanjarPageState();
}

class _CreatePanjarPageState extends State<CreatePanjarPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedDateApi = DateFormat(
    "yyyy-MM-dd HH:mm:ss",
  ).format(DateTime.now());

  String? _selectedEmployeeName;
  int? selectedEmployeeId;
  List<String> employeeNameOptions = [];
  List<int> employeeIdOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Tambah Panjar",
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
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<StorePanjarCubit, StorePanjarState>(
            listener: (context, state) {
              if (state is StorePanjarFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is StorePanjarSuccess) {
                showSuccessDialog(context, "Berhasil buat laporan");
              }
            },
            builder: (context, state) {
              if (state is StorePanjarLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() &&
                      selectedEmployeeId != null) {
                    context.read<StorePanjarCubit>().storeData(
                      data: StorePanjarEntity(
                        userId: selectedEmployeeId!,
                        quantity: int.parse(quantityController.text),
                        note: noteController.text,
                        date: selectedDateApi,
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
                  BlocBuilder<GetListEmployeeCubit, GetListEmployeeState>(
                    builder: (context, state) {
                      if (state is GetListEmployeeLoading) {
                        return const Center(child: CircularProgressIndicator());
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
                            Text("Pegawai"),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == "" || value.toString().isEmpty) {
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
                              items: employeeNameOptions.map((String value) {
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
                                  int index = employeeNameOptions.indexWhere(
                                    (element) => element == newValue,
                                  );
                                  selectedEmployeeId = employeeIdOptions[index];
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
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  Text("Nilai Panjar (Rp.)"),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hint: Text("Contoh 100000")),
                    controller: quantityController,
                    validator: (value) {
                      if (value == "" || value.toString().isEmpty) {
                        return "Isi nilai panjar terlebih dahulu !";
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
                      hint: Text("Masukkan catatan panjar"),
                    ),
                    controller: noteController,
                    validator: (value) {
                      if (value == "" || value.toString().isEmpty) {
                        return "Isi catatan terlebih dahulu !";
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
      selectedDateApi = DateFormat("yyyy-MM-dd HH:mm:ss").format(args);
    });
  }
}
