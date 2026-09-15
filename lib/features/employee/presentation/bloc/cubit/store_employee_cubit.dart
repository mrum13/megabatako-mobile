import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/employee/domain/entities/form_employee_entity.dart';
import 'package:megabatako/features/employee/domain/usecases/store_employee_use_case.dart';

part 'store_employee_state.dart';

class StoreEmployeeCubit extends Cubit<StoreEmployeeState> {
  final StoreEmployeeUseCase _useCase;

  StoreEmployeeCubit(this._useCase) : super(StoreEmployeeInitial());

  void storeData({required FormEmployeeEntity data}) async {
    emit(StoreEmployeeLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StoreEmployeeFailed(failure.message)),
      (data) => emit(StoreEmployeeSuccess(data)),
    );
  }
}
