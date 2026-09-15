import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/employee/domain/repositories/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<Either<Failure, bool>> call({required int id}) {
    return repository.deleteEmployee(id: id);
  }
}