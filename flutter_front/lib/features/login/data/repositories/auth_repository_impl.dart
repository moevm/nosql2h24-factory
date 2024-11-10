import 'package:clean_architecture/features/splash/data/datasources/users_local_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/data/models/logo_model.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_response.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UsersLocalDataSource usersDataSource;
  final Failure failure = ServerFailure();

  AuthRepositoryImpl({required this.remoteDataSource, required this.usersDataSource});

  @override
  Future<Either<Failure, AuthResponseModel>> login(String username, String password) async {
    return performOperation(() async {
      final authResponseModel = await remoteDataSource.login(username, password);
      return authResponseModel;
    }, failure);
  }

  @override
  Future<Either<Failure, LogoModel>> getLogo() async {
    return performOperation(() async {
      final logoModel = await remoteDataSource.getLogo();
      return logoModel;
    }, failure);
  }
}