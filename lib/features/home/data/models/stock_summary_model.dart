import 'package:megabatako/features/home/domain/entities/stock_summary_entity.dart';

class StockSummaryModel extends StockSummaryEntity {
  const StockSummaryModel({
    required super.categoryId, 
    required super.totalStock,
    required super.thumbnail,
    required super.categoryName
  });
  
  factory StockSummaryModel.fromJson(Map<String, dynamic> json) =>
      StockSummaryModel(
        categoryId : json["category_id"],
        totalStock : json["total_stock"],
        thumbnail : json["thumbnail"],
        categoryName: json["category_name"]
      );
}