part of 'get_list_employee_cubit.dart';

sealed class GetListEmployeeState extends Equatable {
  const GetListEmployeeState();

  @override
  List<Object> get props => [];
}

final class GetListEmployeeInitial extends GetListEmployeeState {}

final class GetListEmployeeLoading extends GetListEmployeeState {}

final class GetListEmployeeSuccess extends GetListEmployeeState {
  final List<EmployeeEntity> data;

  const GetListEmployeeSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetListEmployeeFailed extends GetListEmployeeState {
  final String message;

  const GetListEmployeeFailed(this.message);

  @override
  List<Object> get props => [message];
}
