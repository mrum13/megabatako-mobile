import 'package:equatable/equatable.dart';

class FormEmployeeEntity extends Equatable {
  const FormEmployeeEntity({
    required this.name, 
    required this.email,
    required this.password,
    required this.role});

  final String name;
  final String email;
  final String password;
  final String role;

  @override
  List<Object> get props => [name, email, password, role];
}