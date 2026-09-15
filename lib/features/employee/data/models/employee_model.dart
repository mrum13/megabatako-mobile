import 'package:megabatako/features/employee/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id, 
    required super.name,
    required super.email,
    required super.role,
  });
  
  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      EmployeeModel(
        id : json["id"],
        name : json["name"],
        email : json["email"],
        role : json["role"],
      );
}