import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/warning.dart';
import '../entities/warnings_data.dart';
import '../usecases/get_warnings_usecase.dart';

abstract class WarningsRepository {
  Future<Either<Failure, WarningsData>> getWarnings(Map<String, dynamic> params);
  Future<Either<Failure, void>> warningsViewed(Map<String, dynamic> body);
  Future<Either<Failure, void>> addDescription(Map<String, dynamic> body);
}