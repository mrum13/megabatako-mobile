part of 'get_withdraw_cubit.dart';

sealed class GetWithdrawState extends Equatable {
  const GetWithdrawState();

  @override
  List<Object> get props => [];
}

final class GetWithdrawInitial extends GetWithdrawState {}

final class GetWithdrawLoading extends GetWithdrawState {}

final class GetWithdrawSuccess extends GetWithdrawState {
  final List<WithdrawEntity> data;

  const GetWithdrawSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetWithdrawFailed extends GetWithdrawState {
  final String message;

  const GetWithdrawFailed(this.message);

  @override
  List<Object> get props => [message];
}