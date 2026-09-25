import 'package:megabatako/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<bool> call() => _authRepository.signOut();
}