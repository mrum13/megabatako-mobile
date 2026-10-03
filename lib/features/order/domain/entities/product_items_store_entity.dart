import 'package:equatable/equatable.dart';

class ProductItemsStoreEntity extends Equatable {
  final int idProduct;
  final String productName;
  final String productPrice;
  final int productQuantity;
  final String productImage;

  const ProductItemsStoreEntity({
    required this.idProduct,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImage
  });
  
  @override
  List<Object?> get props => [
    idProduct,
    productName,
    productPrice,
    productQuantity,
    productImage
  ];

}