import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/withdraw/domain/entities/withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/usecases/get_withdraw_use_case.dart';

part 'get_withdraw_state.dart';

class GetWithdrawCubit extends Cubit<GetWithdrawState> {
  final GetWithdrawUseCase _useCase;
  GetWithdrawCubit(this._useCase) : super(GetWithdrawInitial());

  void getData({required int userId}) async {
    emit(GetWithdrawLoading());

    final result = await _useCase(userId: userId);

    result.fold(
      (failure) => emit(GetWithdrawFailed(failure.message)),
      (data) => emit(GetWithdrawSuccess(data)),
    );
  }
}
