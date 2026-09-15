import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/home/domain/entities/stock_summary_entity.dart';
import 'package:megabatako/features/home/domain/use_cases/get_stock_summary_use_case.dart';

part 'get_stock_summary_state.dart';

class GetStockSummaryCubit extends Cubit<GetStockSummaryState> {
  final GetStockSummaryUseCase _useCase;

  GetStockSummaryCubit(this._useCase) : super(GetStockSummaryInitial());

  void getData() async {
    emit(GetStockSummaryLoading());

    final result = await _useCase();

    result.fold(
      (failure) => emit(GetStockSummaryFailed(failure.message)),
      (data) => emit(GetStockSummarySuccess(data)),
    );
  }
}
