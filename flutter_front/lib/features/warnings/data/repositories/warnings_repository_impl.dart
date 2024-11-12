import 'package:clean_architecture/features/warnings/data/datasources/warnings_remote_datasource.dart';
import 'package:clean_architecture/features/warnings/data/models/warnings_response_model.dart';
import 'package:clean_architecture/features/warnings/domain/entities/warning.dart';
import 'package:clean_architecture/features/warnings/domain/entities/warnings_data.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../domain/repositories/warnings_repository.dart';
import '../../domain/usecases/get_warnings_usecase.dart';

class WarningsRepositoryImpl extends BaseRepository implements WarningsRepository {
  final WarningsRemoteDataSource remoteDataSource;

  WarningsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, WarningsData>> getWarnings(Map<String, dynamic> params) async {
      try {
        final warnings = await remoteDataSource.getWarnings(params);
        return Right(warnings.toEntity());
      } catch (e) {
        return Left(ServerFailure());
      }
  }

  @override
  Future<Either<Failure, void>> warningsViewed(Map<String, dynamic> body) =>
      performOperation(() => remoteDataSource.warningsViewed(body), ServerFailure());

  @override
  Future<Either<Failure, void>> addDescription(Map<String, dynamic> body) =>
      performOperation(() => remoteDataSource.addDescription(body), ServerFailure());
}
