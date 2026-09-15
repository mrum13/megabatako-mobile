part of 'delete_employee_cubit.dart';

sealed class DeleteEmployeeState extends Equatable {
  const DeleteEmployeeState();

  @override
  List<Object> get props => [];
}

final class DeleteEmployeeInitial extends DeleteEmployeeState {}

final class DeleteEmployeeLoading extends DeleteEmployeeState {}

final class DeleteEmployeeSuccess extends DeleteEmployeeState {
  final bool status;

  const DeleteEmployeeSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class DeleteEmployeeFailed extends DeleteEmployeeState {
  final String message;

  const DeleteEmployeeFailed(this.message);

  @override
  List<Object> get props => [message];
}