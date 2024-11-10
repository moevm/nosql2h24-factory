import 'dart:math';

import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository loginRepository;
  final SplashRepository splashRepository;
  final HiveRepository hiveRepository;

  LoginUseCase({required this.loginRepository, required this.hiveRepository, required this.splashRepository});

  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
    try {
      final tokenResult =
          await loginRepository.login(params.username, params.password);
      return tokenResult.fold(
        (failure) => Left(failure),
        (model) async {
          try {
            await hiveRepository.initializeUserBox(model.username);
            await hiveRepository.saveUsername(model.username);
            if(params.rememberMe) await splashRepository.saveUser(model.username);
            await hiveRepository.saveToken(model.accessToken);
            await hiveRepository.saveRefreshToken(model.requestToken);
            final logoResult = await loginRepository.getLogo();
            return logoResult.fold(
                    (failure) => Left(failure),
                    (logo) async {
                      await hiveRepository.saveLogo(logo.logo);
                      return const Right(null);
                    });
          } catch (e) {
            return Left(CacheFailure());
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

class LoginParams {
  final String username;
  final String password;
  final bool rememberMe;

  LoginParams({required this.username, required this.password, required this.rememberMe});
}
