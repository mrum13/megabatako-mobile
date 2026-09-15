import 'package:megabatako/features/employee/domain/entities/form_employee_entity.dart';

class FormEmployeeModel extends FormEmployeeEntity {
  const FormEmployeeModel({
    required super.name,
    required super.email,
    required super.password,
    required super.role,
  });
}