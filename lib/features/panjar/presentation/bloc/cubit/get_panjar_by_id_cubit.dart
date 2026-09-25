import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/panjar/domain/entities/panjar_entity.dart';
import 'package:megabatako/features/panjar/domain/usecases/get_panjar_by_id_use_case.dart';

part 'get_panjar_by_id_state.dart';

class GetPanjarByIdCubit extends Cubit<GetPanjarByIdState> {
  final GetPanjarUseCase _useCase;
  GetPanjarByIdCubit(this._useCase) : super(GetPanjarByIdInitial());

  void getData({required int userId}) async {
    emit(GetPanjarByIdLoading());

    final result = await _useCase(userId: userId);

    result.fold(
      (failure) => emit(GetPanjarByIdFailed(failure.message)),
      (data) => emit(GetPanjarByIdSuccess(data)),
    );
  }
}
