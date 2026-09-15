import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/employee/domain/usecases/delete_employee_use_case.dart';

part 'delete_employee_state.dart';

class DeleteEmployeeCubit extends Cubit<DeleteEmployeeState> {
  final DeleteEmployeeUseCase _useCase;

  DeleteEmployeeCubit(this._useCase) : super(DeleteEmployeeInitial());

  void deleteData({required int id}) async {
    emit(DeleteEmployeeLoading());

    final result = await _useCase(id: id);

    result.fold(
      (failure) => emit(DeleteEmployeeFailed(failure.message)),
      (data) => emit(DeleteEmployeeSuccess(data)),
    );
  }
}
