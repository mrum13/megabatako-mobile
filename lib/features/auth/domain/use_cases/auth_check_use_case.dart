import 'package:megabatako/features/auth/domain/repositories/auth_repository.dart';

class AuthCheckUseCase {
  final AuthRepository _authRepository;

  AuthCheckUseCase(this._authRepository);

  Future<bool> call() => _authRepository.getIsLoggedIn();
}