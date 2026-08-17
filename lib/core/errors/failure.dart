import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class RequestValidationFailure extends Failure {
  const RequestValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Terjadi kesalahan yang tidak diketahui']);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class ImagePickFailure extends Failure {
  const ImagePickFailure(super.message);
}
