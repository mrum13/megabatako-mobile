import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/report/domain/entities/mark_date_entity.dart';
import 'package:megabatako/features/report/domain/usecases/get_report_date_use_case.dart';

part 'get_report_date_by_id_state.dart';

class GetReportDateByIdCubit extends Cubit<GetReportDateByIdState> {
  final GetReportDateUseCase _useCase;
  GetReportDateByIdCubit(this._useCase) : super(GetReportDateByIdInitial());

  void getData({required int idEmployee}) async {
    emit(GetReportDateByIdLoading());

    final result = await _useCase(idEmployee: idEmployee);

    result.fold(
      (failure) => emit(GetReportDateByIdFailed(failure.message)),
      (data) => emit(GetReportDateByIdSuccess(data)),
    );
  }
}
