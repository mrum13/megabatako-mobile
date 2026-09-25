part of 'get_summary_withdraw_cubit.dart';

sealed class GetSummaryWithdrawState extends Equatable {
  const GetSummaryWithdrawState();

  @override
  List<Object> get props => [];
}

final class GetSummaryWithdrawInitial extends GetSummaryWithdrawState {}

final class GetSummaryWithdrawLoading extends GetSummaryWithdrawState {}

final class GetSummaryWithdrawSuccess extends GetSummaryWithdrawState {
  final SummaryWithdrawEntity data;

  const GetSummaryWithdrawSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetSummaryWithdrawFailed extends GetSummaryWithdrawState {
  final String message;

  const GetSummaryWithdrawFailed(this.message);

  @override
  List<Object> get props => [message];
}