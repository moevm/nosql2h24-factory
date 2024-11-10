import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/data/models/logo_model.dart';
import '../../data/models/auth_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseModel>> login(String username, String password);
  Future<Either<Failure, LogoModel>> getLogo();
}