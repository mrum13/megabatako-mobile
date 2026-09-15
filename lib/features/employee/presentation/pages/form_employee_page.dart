import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/auth/presentation/widgets/text_form_field_bordered.dart';
import 'package:megabatako/features/employee/domain/entities/form_employee_entity.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/store_employee_cubit.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class FormEmployeePage extends StatefulWidget {
  const FormEmployeePage({super.key});

  @override
  State<FormEmployeePage> createState() => _FormEmployeePageState();
}

class _FormEmployeePageState extends State<FormEmployeePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String titleAppBar = "-";
  String? selectedRole;
  List<String> roleOptions = ["owner", "employee"];

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;

    if (data['title']=="edit") {
      nameController.text = data['name'];
      emailController.text = data['email'];
      selectedRole = data['role'];
      titleAppBar = "Edit Pegawai";
    } else {
      titleAppBar = "Tambah Pegawai";
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 80,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: BlocConsumer<StoreEmployeeCubit, StoreEmployeeState>(
            listener: (context, state) {
              if (state is StoreEmployeeSuccess) {
                showSuccessDialog(context, "Berhasil hapus pegawai");
              } else if (state is StoreEmployeeFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is StoreEmployeeLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<StoreEmployeeCubit>().storeData(
                    data: FormEmployeeEntity(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      role: selectedRole!,
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
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          titleAppBar,
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama", style: TextStyle(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              TextFormFieldBordered(
                controller: nameController,
                hint: "Nama Pegawai...",
                validator: (value) {
                  if (value == "" || value.toString().isEmpty) {
                    return "Nama tidak boleh kosong !";
                  }
                  return null;
                },
                obscureText: false,
              ),
              const SizedBox(height: 16),
              Text("Email", style: TextStyle(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              TextFormFieldBordered(
                controller: emailController,
                hint: "Email Pegawai...",
                validator: (value) {
                  if (value == "" || value.toString().isEmpty) {
                    return "Email tidak boleh kosong !";
                  }
                  return null;
                },
                obscureText: false,
              ),
              const SizedBox(height: 16),
              Text("Password", style: TextStyle(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              TextFormFieldBordered(
                controller: passwordController,
                hint: "Password...",
                validator: (value) {
                  if (value == "" || value.toString().isEmpty) {
                    return "Password tidak boleh kosong !";
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Text("Role", style: TextStyle(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == "" || value.toString().isEmpty) {
                    return "Pilih role terlebih dahulu !";
                  }
                  return null;
                },
                initialValue: selectedRole,
                decoration: InputDecoration(
                  hintText: 'Pilih role',
                  hintStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
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
                items: roleOptions.map((String value) {
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
                    selectedRole = newValue;
                  });
                },
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
              ),
            ],
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
      context.read<GetListEmployeeCubit>().getData();
      Navigator.pop(context);
    });
  }
}
