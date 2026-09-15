import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/employee/domain/entities/employee_entity.dart';
import 'package:megabatako/features/employee/domain/usecases/get_employee_use_case.dart';

part 'get_list_employee_state.dart';

class GetListEmployeeCubit extends Cubit<GetListEmployeeState> {
  final GetEmployeeUseCase _useCase;

  GetListEmployeeCubit(this._useCase) : super(GetListEmployeeInitial());

  void getData() async {
    emit(GetListEmployeeLoading());

    final result = await _useCase();

    result.fold(
      (failure) => emit(GetListEmployeeFailed(failure.message)),
      (data) => emit(GetListEmployeeSuccess(data)),
    );
  }
}
