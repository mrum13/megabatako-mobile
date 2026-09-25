part of 'store_panjar_cubit.dart';

sealed class StorePanjarState extends Equatable {
  const StorePanjarState();

  @override
  List<Object> get props => [];
}

final class StorePanjarInitial extends StorePanjarState {}

final class StorePanjarLoading extends StorePanjarState {}

final class StorePanjarSuccess extends StorePanjarState {
  final bool status;

  const StorePanjarSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class StorePanjarFailed extends StorePanjarState {
  final String message;

  const StorePanjarFailed(this.message);

  @override
  List<Object> get props => [message];
}
