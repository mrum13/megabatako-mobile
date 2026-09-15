part of 'get_report_by_id_cubit.dart';

sealed class GetReportByIdState extends Equatable {
  const GetReportByIdState();

  @override
  List<Object> get props => [];
}

final class GetReportByIdInitial extends GetReportByIdState {}

final class GetReportByIdLoading extends GetReportByIdState {}

final class GetReportByIdSuccess extends GetReportByIdState {
  final List<ReportByIdEntity> data;

  const GetReportByIdSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetReportByIdFailed extends GetReportByIdState {
  final String message;

  const GetReportByIdFailed(this.message);

  @override
  List<Object> get props => [message];
}