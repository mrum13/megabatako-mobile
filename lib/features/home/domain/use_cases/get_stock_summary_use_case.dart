import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/home/domain/entities/stock_summary_entity.dart';
import 'package:megabatako/features/home/domain/repositories/home_repository.dart';

class GetStockSummaryUseCase {
  final HomeRepository repository;

  GetStockSummaryUseCase(this.repository);

  Future<Either<Failure, List<StockSummaryEntity>>> call() {
    return repository.getStockSummary();
  }
}