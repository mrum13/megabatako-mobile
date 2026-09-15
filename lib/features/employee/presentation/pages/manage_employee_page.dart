import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megabatako/core/theme/app_colors.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/delete_employee_cubit.dart';
import 'package:megabatako/features/employee/presentation/bloc/cubit/get_list_employee_cubit.dart';
import 'package:megabatako/routes/app_routes.dart';
import 'package:megabatako/widgets/dialog_success.dart';

class ManageEmployeePage extends StatelessWidget {
  const ManageEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Manajemen Pegawai",
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
              Navigator.pushNamed(
                context,
                AppRoutes.formEmployeePage,
                arguments: {
                  'title': "store",
                  'id':0,
                  'name':"",
                  'email':"",
                  'role':""
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
            BlocListener<DeleteEmployeeCubit, DeleteEmployeeState>(
              listener: (context, state) {
                if (state is DeleteEmployeeSuccess) {
                  showSuccessDialog(context, "Berhasil hapus pegawai");
                } else if (state is DeleteEmployeeFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<GetListEmployeeCubit, GetListEmployeeState>(
            builder: (context, state) {
              if (state is GetListEmployeeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetListEmployeeFailed) {
                return Center(child: Text(state.message));
              } else if (state is GetListEmployeeSuccess) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.data[index].name),
                      subtitle: Text(state.data[index].role),
                      leading: Icon(Icons.account_circle_rounded, size: 56),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.formEmployeePage,
                                arguments: {
                                  'title': "edit",
                                  'id': state.data[index].id,
                                  'name':state.data[index].name,
                                  'email':state.data[index].email,
                                  'role':state.data[index].role
                                },
                              );
                            },
                            icon: CircleAvatar(child: Icon(Icons.edit)),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus User'),
                                  content: const Text(
                                    'Yakin ingin menghapus user ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context
                                            .read<DeleteEmployeeCubit>()
                                            .deleteData(
                                              id: state.data[index].id,
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
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                  itemCount: state.data.length,
                );
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
        return DialogSuccess(value: value);
      },
    ).then((value) {
      context.read<GetListEmployeeCubit>().getData();
    });
  }
}
