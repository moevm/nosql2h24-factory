import 'package:clean_architecture/features/warnings/data/models/description_model.dart';
import 'package:clean_architecture/features/warnings/domain/entities/description.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/warnings_repository.dart';

class UpdateWarningDescriptionUseCase implements UseCase<void, UpdateWarningDescriptionParams>{
  final WarningsRepository repository;
  final HiveRepository hiveRepository;
  UpdateWarningDescriptionUseCase(this.repository, this.hiveRepository);

  @override
  Future<Either<Failure, Description?>> call(UpdateWarningDescriptionParams param) async {
    final usernameRes = await hiveRepository.getUsername();
    return usernameRes.fold(
        (f) => Left(f),
        (username) async {
          username ??= "Неизвестно";
          final Description? description = param.descriptionText == "" ? null :
          Description(
              text: param.descriptionText,
              updated: DateTime.now(),
              author: username);
          final map = {
            "id": param.id,
            "description": description == null ? null : DescriptionModel.fromEntity(description).toJson()
          };
          final descriptionRes = await repository.addDescription(map);
          return descriptionRes.fold(
              (f) => Left(f),
              (_) =>  Right(description)
          );
        }
    );
  }
}

class UpdateWarningDescriptionParams{
  String descriptionText;
  String id;

  UpdateWarningDescriptionParams(this.descriptionText, this.id);
}