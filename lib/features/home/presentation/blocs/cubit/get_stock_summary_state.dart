part of 'get_stock_summary_cubit.dart';

sealed class GetStockSummaryState extends Equatable {
  const GetStockSummaryState();

  @override
  List<Object> get props => [];
}

final class GetStockSummaryInitial extends GetStockSummaryState {}

final class GetStockSummaryLoading extends GetStockSummaryState {}

final class GetStockSummarySuccess extends GetStockSummaryState {
  final List<StockSummaryEntity> data;

  const GetStockSummarySuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetStockSummaryFailed extends GetStockSummaryState {
  final String message;

  const GetStockSummaryFailed(this.message);

  @override
  List<Object> get props => [message];
}
