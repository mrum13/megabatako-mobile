import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  const EmployeeEntity({
    required this.id,
    required this.name, 
    required this.email,
    required this.role});

  final int id;
  final String name;
  final String email;
  final String role;

  @override
  List<Object> get props => [id, name, email, role];
}