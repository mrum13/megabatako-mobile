import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/report/domain/entities/summary_withdraw_entity.dart';
import 'package:megabatako/features/report/domain/usecases/get_summary_use_case.dart';

part 'get_summary_withdraw_state.dart';

class GetSummaryWithdrawCubit extends Cubit<GetSummaryWithdrawState> {
  final GetSummaryUseCase _useCase;

  GetSummaryWithdrawCubit(this._useCase) : super(GetSummaryWithdrawInitial());

  void getData({required int idEmployee}) async {
    emit(GetSummaryWithdrawLoading());

    final result = await _useCase(idEmployee: idEmployee);

    result.fold(
      (failure) => emit(GetSummaryWithdrawFailed(failure.message)),
      (data) => emit(GetSummaryWithdrawSuccess(data)),
    );
  }
}
