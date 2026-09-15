import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/report/domain/entities/report_by_id_entity.dart';
import 'package:megabatako/features/report/domain/usecases/get_report_use_case.dart';

part 'get_report_by_id_state.dart';

class GetReportByIdCubit extends Cubit<GetReportByIdState> {
  final GetReportUseCase _useCase;

  GetReportByIdCubit(this._useCase) : super(GetReportByIdInitial());

  void getData({required int idEmployee, required String date}) async {
    emit(GetReportByIdLoading());

    final result = await _useCase(idEmployee: idEmployee, date: date);

    result.fold(
      (failure) => emit(GetReportByIdFailed(failure.message)),
      (data) => emit(GetReportByIdSuccess(data)),
    );
  }
}
