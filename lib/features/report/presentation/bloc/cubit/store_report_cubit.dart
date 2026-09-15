import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/report/domain/entities/store_report_entity.dart';
import 'package:megabatako/features/report/domain/usecases/store_report_use_case.dart';

part 'store_report_state.dart';

class StoreReportCubit extends Cubit<StoreReportState> {
  final StoreReportUseCase _useCase;

  StoreReportCubit(this._useCase) : super(StoreReportInitial());

  void storeData({required StoreReportEntity data}) async {
    emit(StoreReportLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StoreReportFailed(failure.message)),
      (data) => emit(StoreReportSuccess(data)),
    );
  }
}
