import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/order/domain/entities/order_entity.dart';
import 'package:megabatako/features/order/domain/use_cases/get_order_use_case.dart';

part 'get_order_state.dart';

class GetOrderCubit extends Cubit<GetOrderState> {
  final GetOrderUseCase _useCase;

  GetOrderCubit(this._useCase) : super(GetOrderInitial());

  void getData({required String date}) async {
    emit(GetOrderLoading());

    final result = await _useCase(date: date);

    result.fold(
      (failure) => emit(GetOrderFailed(failure.message)),
      (data) => emit(GetOrderSuccess(data)),
    );
  }
}
