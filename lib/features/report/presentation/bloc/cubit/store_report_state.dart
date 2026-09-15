part of 'store_report_cubit.dart';

sealed class StoreReportState extends Equatable {
  const StoreReportState();

  @override
  List<Object> get props => [];
}

final class StoreReportInitial extends StoreReportState {}

final class StoreReportLoading extends StoreReportState {}

final class StoreReportSuccess extends StoreReportState {
  final bool status;

  const StoreReportSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreReportFailed extends StoreReportState {
  final String message;

  const StoreReportFailed(this.message);

  @override
  List<Object> get props => [message];
}