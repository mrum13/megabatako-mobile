import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/order/domain/use_cases/update_order_status_use_case.dart';

part 'update_order_status_state.dart';

class UpdateOrderStatusCubit extends Cubit<UpdateOrderStatusState> {
  final UpdateOrderStatusUseCase _useCase;
  UpdateOrderStatusCubit(this._useCase) : super(UpdateOrderStatusInitial());

  void updateData({required int id}) async {
    emit(UpdateOrderStatusLoading());

    final result = await _useCase(id: id);

    result.fold(
      (failure) => emit(UpdateOrderStatusFailed(failure.message)),
      (data) => emit(UpdateOrderStatusSuccess(data)),
    );
  }
}
