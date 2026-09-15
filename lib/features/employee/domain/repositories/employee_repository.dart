import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/employee/domain/entities/employee_entity.dart';
import 'package:megabatako/features/employee/domain/entities/form_employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getEmployee();
  Future<Either<Failure, bool>> storeEmployee({required FormEmployeeEntity data});
  Future<Either<Failure, bool>> deleteEmployee({required int id});
}