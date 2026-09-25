import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/auth/domain/use_cases/auth_check_use_case.dart';
import 'package:megabatako/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:megabatako/features/auth/domain/use_cases/sign_out_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._signInUseCase,
    this._authCheckUseCase,
    this._signOutUseCase
  ) : super(SignInInitial());

  final SignInUseCase _signInUseCase;
  final AuthCheckUseCase _authCheckUseCase;
  final SignOutUseCase _signOutUseCase;

  void signin({required String email, required String password}) async {
    emit(SignInLoading());

    final result = await _signInUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(SignInFailed(failure.message)),
      (data) => emit(SignInSuccess(data)),
    );
  }

  void setInit() {
    emit(SignInInitial());
  }

  Future<void> checkAuth() async {
    final loggedIn = await _authCheckUseCase();
    emit(loggedIn ? SignInSuccess(true) : SignInInitial());
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    emit(SignInInitial());
  }
}
