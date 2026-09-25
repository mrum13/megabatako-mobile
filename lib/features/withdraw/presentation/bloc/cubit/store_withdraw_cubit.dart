import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/withdraw/domain/entities/store_withdraw_entity.dart';
import 'package:megabatako/features/withdraw/domain/usecases/store_withdraw_use_case.dart';

part 'store_withdraw_state.dart';

class StoreWithdrawCubit extends Cubit<StoreWithdrawState> {
  final StoreWithdrawUseCase _useCase;
  StoreWithdrawCubit(this._useCase) : super(StoreWithdrawInitial());

  void storeData({required StoreWithdrawEntity data}) async {
    emit(StoreWithdrawLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StoreWithdrawFailed(failure.message)),
      (data) => emit(StoreWithdrawSuccess(data)),
    );
  }
}
