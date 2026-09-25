part of 'store_withdraw_cubit.dart';

sealed class StoreWithdrawState extends Equatable {
  const StoreWithdrawState();

  @override
  List<Object> get props => [];
}

final class StoreWithdrawInitial extends StoreWithdrawState {}

final class StoreWithdrawLoading extends StoreWithdrawState {}

final class StoreWithdrawSuccess extends StoreWithdrawState {
  final bool status;

  const StoreWithdrawSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreWithdrawFailed extends StoreWithdrawState {
  final String message;

  const StoreWithdrawFailed(this.message);

  @override
  List<Object> get props => [message];
}
