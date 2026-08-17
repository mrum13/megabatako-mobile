import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<Either<Failure, bool>> call({
    required String email, 
    required String password, 
  }) {
    return _authRepository.signin(
      email: email, 
      password: password, 
    );
  }
}