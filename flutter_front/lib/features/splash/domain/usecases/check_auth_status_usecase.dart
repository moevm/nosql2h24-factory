import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../../login/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements UseCase<List<String>, NoParams> {
  final SplashRepository splashRepository;

  CheckAuthStatusUseCase(this.splashRepository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    try{
      await splashRepository.initBox();
      final usersRes = await splashRepository.getUsers();
      return usersRes.fold((f) => Left(CacheFailure()),
          (users) => Right(users));
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}