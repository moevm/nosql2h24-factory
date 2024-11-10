import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/usecases/no_params.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final SplashRepository splashRepository;
  final HiveRepository hiveRepository;

  LogoutUseCase(this.splashRepository, this.hiveRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try{
      final usernameRes = await hiveRepository.getUsername();
      return usernameRes.fold(
          (f) => const Right(null),
          (username) async {
            if(username != null){
              await Hive.deleteBoxFromDisk("user_$username");
              await splashRepository.deleteUser(username);
            }
            return const Right(null);
          });
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}