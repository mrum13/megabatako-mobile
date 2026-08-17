import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/account/domain/entities/user_entity.dart';
import 'package:megabatako/features/account/domain/use_cases/get_current_user_use_case.dart';

part 'get_current_user_state.dart';

class GetCurrentUserCubit extends Cubit<GetCurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  GetCurrentUserCubit(this._getCurrentUserUseCase) : super(GetCurrentUserInitial());

  void getCurrentUser() async {
    emit(GetCurrentUserLoading());

    var result = await _getCurrentUserUseCase();

    result.fold(
      (failure) => emit(GetCurrentUserFailed(failure.message)),
      (data) => emit(GetCurrentUserSuccess(data)),
    );
  }
}
