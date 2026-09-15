part of 'store_employee_cubit.dart';

sealed class StoreEmployeeState extends Equatable {
  const StoreEmployeeState();

  @override
  List<Object> get props => [];
}

final class StoreEmployeeInitial extends StoreEmployeeState {}

final class StoreEmployeeLoading extends StoreEmployeeState {}

final class StoreEmployeeSuccess extends StoreEmployeeState {
  final bool status;

  const StoreEmployeeSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StoreEmployeeFailed extends StoreEmployeeState {
  final String message;

  const StoreEmployeeFailed(this.message);

  @override
  List<Object> get props => [message];
}