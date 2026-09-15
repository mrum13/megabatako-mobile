import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/home/domain/entities/stock_summary_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<StockSummaryEntity>>> getStockSummary();
}