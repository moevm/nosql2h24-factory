import 'package:clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRepository {

  BaseRepository();

  Future<Either<Failure, T>> performOperation<T>(Future<T> Function() operation, Failure failure) async {
      try {
        final result = await operation();
        return Right(result);
      } on Exception catch (e) {
        return Left(failure);
      }
  }

  // Обобщенный метод для выполнения операций, которые могут вернуть null
  Future<Either<Failure, T?>> performNullableOperation<T>(Future<T?> Function() operation, Failure failure) async {
      try {
        final result = await operation();
        return Right(result);
      } on Exception catch (e) {
        return Left(failure);
      }
  }

  // Обобщенный метод для выполнения операций, которые не должны возвращать null
  Future<Either<Failure, T>> performNonNullOperation<T>(Future<T?> Function() operation, Failure failure) async {
      try {
        final result = await operation();
        if (result == null) {
          return Left(failure);
        }
        return Right(result);
      } on Exception catch (e) {
        return Left(failure);
      }
  }
}