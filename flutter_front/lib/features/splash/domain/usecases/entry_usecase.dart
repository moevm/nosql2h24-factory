import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/hive_repository.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../../login/domain/repositories/auth_repository.dart';

class EntryUseCase implements UseCase<void, String> {
  final HiveRepository hiveRepository;

  EntryUseCase(this.hiveRepository);

  @override
  Future<Either<Failure, void>> call(String username) async {
    try{
      await hiveRepository.initializeUserBox(username);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}