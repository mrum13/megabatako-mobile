part of 'get_report_date_by_id_cubit.dart';

sealed class GetReportDateByIdState extends Equatable {
  const GetReportDateByIdState();

  @override
  List<Object> get props => [];
}

final class GetReportDateByIdInitial extends GetReportDateByIdState {}

final class GetReportDateByIdLoading extends GetReportDateByIdState {}

final class GetReportDateByIdSuccess extends GetReportDateByIdState {
  final List<MarkDateEntity> data;

  const GetReportDateByIdSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetReportDateByIdFailed extends GetReportDateByIdState {
  final String message;

  const GetReportDateByIdFailed(this.message);

  @override
  List<Object> get props => [message];
}