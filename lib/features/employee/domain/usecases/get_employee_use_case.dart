import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/employee/domain/entities/employee_entity.dart';
import 'package:megabatako/features/employee/domain/repositories/employee_repository.dart';

class GetEmployeeUseCase {
  final EmployeeRepository repository;

  GetEmployeeUseCase(this.repository);

  Future<Either<Failure, List<EmployeeEntity>>> call() {
    return repository.getEmployee();
  }
}