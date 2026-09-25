part of 'get_panjar_by_id_cubit.dart';

sealed class GetPanjarByIdState extends Equatable {
  const GetPanjarByIdState();

  @override
  List<Object> get props => [];
}

final class GetPanjarByIdInitial extends GetPanjarByIdState {}

final class GetPanjarByIdLoading extends GetPanjarByIdState {}

final class GetPanjarByIdSuccess extends GetPanjarByIdState {
  final PanjarEntity data;

  const GetPanjarByIdSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetPanjarByIdFailed extends GetPanjarByIdState {
  final String message;

  const GetPanjarByIdFailed(this.message);

  @override
  List<Object> get props => [message];
}