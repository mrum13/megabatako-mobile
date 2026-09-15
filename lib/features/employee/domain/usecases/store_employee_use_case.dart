import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/employee/domain/entities/form_employee_entity.dart';
import 'package:megabatako/features/employee/domain/repositories/employee_repository.dart';

class StoreEmployeeUseCase {
  final EmployeeRepository repository;

  StoreEmployeeUseCase(this.repository);

  Future<Either<Failure, bool>> call({required FormEmployeeEntity data}) {
    return repository.storeEmployee(data: data);
  }
}