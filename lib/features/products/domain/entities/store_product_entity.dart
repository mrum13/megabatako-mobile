import 'dart:io';

import 'package:equatable/equatable.dart';

class StoreProductEntity extends Equatable {
  const StoreProductEntity({
    required this.productCategoryId, 
    required this.name,
    required this.price,
    required this.thumbnail,
    required this.stock,
    required this.desc,
  });

  final int productCategoryId;
  final String name;
  final String price;
  final String? thumbnail;
  final String stock;
  final String desc;


  @override
  List<Object> get props => [
    productCategoryId,
    name,
    price,
    thumbnail!,
    stock,
    desc,
  ];
}