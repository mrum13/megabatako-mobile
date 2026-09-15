import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({required this.id, required this.name, required this.email, required this.role});

  final int id;
  final String name;
  final String email;
  final String role;

  @override
  List<Object> get props => [name, email, role];
}