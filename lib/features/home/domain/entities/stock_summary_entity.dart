import 'package:equatable/equatable.dart';

class StockSummaryEntity extends Equatable {
  const StockSummaryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.totalStock,
    required this.thumbnail,
  });

  final int categoryId;
  final String categoryName;
  final String totalStock;
  final String thumbnail;

  @override
  List<Object> get props => [categoryId, categoryName, totalStock, thumbnail];
}
