import 'package:dartz/dartz.dart';
import 'package:megabatako/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signin({
    required String email, 
    required String password, 
  });

}