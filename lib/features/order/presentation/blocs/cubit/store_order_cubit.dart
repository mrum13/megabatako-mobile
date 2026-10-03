import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/order/domain/entities/store_order_entity.dart';
import 'package:megabatako/features/order/domain/use_cases/store_order_use_case.dart';

part 'store_order_state.dart';

class StoreOrderCubit extends Cubit<StoreOrderState> {
  final StoreOrderUseCase _useCase;

  StoreOrderCubit(this._useCase) : super(StoreOrderInitial());

  void storeData({required StoreOrderEntity data}) async {
    emit(StoreOrderLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StoreOrderFailed(failure.message)),
      (data) => emit(StoreOrderSuccess(data)),
    );
  }
}
