import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/panjar/domain/entities/store_panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/usecases/store_panjar_use_case.dart';

part 'store_panjar_state.dart';

class StorePanjarCubit extends Cubit<StorePanjarState> {
  final StorePanjarUseCase _useCase;
  StorePanjarCubit(this._useCase) : super(StorePanjarInitial());

  void storeData({required StorePanjarEntity data}) async {
    emit(StorePanjarLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StorePanjarFailed(failure.message)),
      (data) => emit(StorePanjarSuccess(data)),
    );
  }
}
