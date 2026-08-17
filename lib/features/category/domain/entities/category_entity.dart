import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object> get props => [name, id];
}