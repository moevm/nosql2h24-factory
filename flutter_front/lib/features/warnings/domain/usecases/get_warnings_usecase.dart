import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/domain/repositories/equipment_repository.dart';
import '../entities/warnings_data.dart';
import '../repositories/warnings_repository.dart';

class GetWarningsUseCase {
  final WarningsRepository warningsRepository;
  final EquipmentRepository equipmentRepository;

  GetWarningsUseCase(this.warningsRepository, this.equipmentRepository);

  Future<Either<Failure, WarningsData>> call(
      GetWarningsUseCaseParams params) async {
    final warningsRes =
    await warningsRepository.getWarnings(params.toJson());
    return warningsRes.fold((f) => Left(f), (data) async {
      final equipRes = await equipmentRepository.getEquipment();
      return equipRes.fold((e) => Left(ServerFailure()), (equipment) {
        data.equipment = equipment;
        return Right(data);
      });
    });
  }
}

class GetWarningsUseCaseParams {
  final int page;
  final double excessPercent;
  final String? equipmentKey;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool orderAscending;
  final bool withDescription;
  final bool? viewed;

  GetWarningsUseCaseParams({
    required this.page,
    required this.excessPercent,
    this.equipmentKey,
    this.startDate,
    this.endDate,
    this.orderAscending = true,
    this.withDescription = false,
    this.viewed,
  });

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    return {
      'page': page.toString(),
      'excess_percent': excessPercent.toString(),
      if (equipmentKey != null) 'equipment_key': equipmentKey,
      if (startDate != null) 'start_date': formatter.format(startDate!),
      if (endDate != null) 'end_date': formatter.format(endDate!),
      'order_ascending': orderAscending.toString(),
      'with_description': withDescription.toString(),
      if (viewed != null) 'viewed': viewed.toString(),
    };
  }
}