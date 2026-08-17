import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/auth/domain/use_cases/sign_in_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._useCase) : super(SignInInitial());

  final SignInUseCase _useCase;

  void signin({
    required String email,
    required String password,
  }) async {

    emit(SignInLoading());

    final result = await _useCase(
      email: email, 
      password: password
    );

    result.fold(
      (failure) => emit(SignInFailed(failure.message)),
      (data) => emit(SignInSuccess(data)),
    );
  }
}
