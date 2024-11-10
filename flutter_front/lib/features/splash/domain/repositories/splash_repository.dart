import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class SplashRepository {
  Future<Either<Failure, void>> initBox();
  Future<Either<Failure, void>> saveUser(String username);
  Future<Either<Failure, void>> deleteUser(String username);
  Future<Either<Failure, List<String>>> getUsers();
}