part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final bool status; 

  const SignInSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class SignInFailed extends SignInState {
  final String message;
  
  const SignInFailed(this.message);

  @override
  List<Object> get props => [message];

}
