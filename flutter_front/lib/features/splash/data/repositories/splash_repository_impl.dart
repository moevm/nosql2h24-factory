import 'package:clean_architecture/features/splash/data/datasources/users_local_data_source.dart';
import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/data/repositories/base_repository.dart';

class SplashRepositoryImpl extends BaseRepository implements SplashRepository {
  final UsersLocalDataSource usersDataSource;
  final Failure failure = ServerFailure();

  SplashRepositoryImpl({required this.usersDataSource});

  @override

  @override
  Future<Either<Failure, List<String>>> getUsers() {
    return performOperation(() async {
      final users = await usersDataSource.getUsers();
      return users;
    }, failure);
  }

  @override
  Future<Either<Failure, void>> initBox() {
    return performOperation(() async => usersDataSource.initializeBox() , failure);
  }

  @override
  Future<Either<Failure, void>> saveUser(String username) {
    return performOperation(() async => usersDataSource.addUser(username) , failure);
  }

  @override
  Future<Either<Failure, void>> deleteUser(String username) {
    return performOperation(() async => usersDataSource.removeUser(username) , failure);
  }
}