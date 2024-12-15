import 'package:clean_architecture/features/statistics/data/models/statistics_model.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/domain/usecases/get_equipment_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/optional.dart';
import '../../../../shared/domain/entities/percentage_entity.dart';
import '../../../../shared/domain/usecases/get_chosen_equipment.dart';
import '../../../../shared/domain/usecases/get_excess_percent.dart';
import '../../../../shared/domain/usecases/get_timerange.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../../../shared/domain/usecases/set_chosen_equipment.dart';
import '../../../../shared/domain/usecases/set_excess_percent.dart';
import '../../../../shared/domain/usecases/set_timerange.dart';
import '../../../settings/presentation/widgets/settings_message.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/entities/warning_statistics_entity.dart';
import '../../domain/usecases/get_equipment_warnings_statistics.dart';
import '../../domain/usecases/get_equipment_working_percentage.dart';
import '../../domain/usecases/get_statistic_working_percentage.dart';
import '../../domain/usecases/get_warning_statistics_usecase.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetTimeRangeUseCase getTimeRange;
  final SaveTimeRangeUseCase saveTimeRange;
  final GetExcessPercentUseCase getExcessPercent;
  final SetExcessPercentUseCase saveExcessPercent;
  final GetChosenEquipmentUseCase getSelectedEquipment;
  final SetChosenEquipmentUseCase saveSelectedEquipment;
  final GetEquipmentUseCase getEquipmentList;
  final GetWarningStatisticsUseCase getWarningStatistics;
  final GetStatisticWorkingPercentageUseCase getStatisticWorkingPercentage;
  final GetEquipmentWorkingPercentage getEquipmentWorkingPercentage;
  final GetEquipmentWarningsStatistics getEquipmentWarningsStatistics;

  StatisticsBloc({
    required this.getTimeRange,
    required this.saveTimeRange,
    required this.getExcessPercent,
    required this.saveExcessPercent,
    required this.getSelectedEquipment,
    required this.saveSelectedEquipment,
    required this.getEquipmentList,
    required this.getWarningStatistics,
    required this.getStatisticWorkingPercentage,
    required this.getEquipmentWorkingPercentage,
    required this.getEquipmentWarningsStatistics,
  }) : super(StatisticsInitial()) {
    on<InitializeStatistics>(_onInitializeStatistics);
    on<FetchStatistics>(_onFetchStatistics);
    on<UpdateGroupBy>(_onUpdateGroupBy);
    on<UpdateMetric>(_onUpdateMetric);
    on<SaveDateTimeRange>(_onSaveDateTimeRange);
    on<SaveExcessPercentEvent>(_onSaveExcessPercent);
    on<SaveSelectedEquipmentEvent>(_onSaveSelectedEquipment);
  }

  Future<void> _onInitializeStatistics(InitializeStatistics event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());

    final dateTimeRangeResult = await getTimeRange(NoParams());
    final excessPercentResult = await getExcessPercent(NoParams());
    final selectedEquipmentResult = await getSelectedEquipment(NoParams());
    final equipmentListResult = await getEquipmentList(NoParams());

    if (equipmentListResult.isRight()) {
      final equipmentList = equipmentListResult.getOrElse(() => const EquipmentListEntity(equipment: []));

      final double excessPercent = excessPercentResult.getOrElse(() => 0) ?? 0;
      final String? selectedEquipment = selectedEquipmentResult.getOrElse(() => null);
      final DateTimeRange dateTimeRange = dateTimeRangeResult.getOrElse(() {
        final now = DateTime.now();
        return DateTimeRange(
          start: DateTime(2024, 11, 6),
          end: DateTime(2024, 11, 8),
        );
      });

      emit(StatisticsLoaded(
        equipmentList: equipmentList,
        excessPercent: excessPercent,
        selectedEquipmentKey: selectedEquipment,
        startDate: dateTimeRange.start,
        endDate: dateTimeRange.end,
      ));

      add(FetchStatistics(
        excessPercent: excessPercent,
        equipmentKey: selectedEquipment,
        startDate: dateTimeRange.start,
        endDate: dateTimeRange.end,
      ));
    } else {
      emit(StatisticsError("Не удалось загрузить список оборудования"));
    }
  }

  Future<void> _onFetchStatistics(FetchStatistics event, Emitter<StatisticsState> emit) async {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;

      if (event.startDate == null || event.endDate == null) {
        emit(currentState.copyWith(
          excessPercent: event.excessPercent,
          selectedEquipmentKey: Optional(event.equipmentKey),
          startDate: event.startDate,
          endDate: event.endDate,
        ));
        return;
      }

      emit(StatisticsFetching(currentState));

      final statisticsResult = await getWarningStatistics(
        GetWarningStatisticsParams(
          startDate: event.startDate!,
          endDate: event.endDate!,
          equipment: event.equipmentKey,
          groupBy: currentState.selectedGroupBy.value,
          metric: currentState.selectedMetric.value,
          excessPercent: currentState.excessPercent,
        ),
      );

      final percentResult = await getStatisticWorkingPercentage(
        GetStatisticWorkingPercentageParams(
          startDate: event.startDate!,
          endDate: event.endDate!,
          equipment: event.equipmentKey,
          groupBy: currentState.selectedGroupBy.value,
        ),
      );

      final equipmentPercentResult = await getEquipmentWorkingPercentage(
        GetEquipmentWorkingPercentageParams(
          startDate: event.startDate!,
          endDate: event.endDate!,
          equipment: event.equipmentKey,
        ),
      );

      final warningStatisticsResult = await getEquipmentWarningsStatistics(
        GetEquipmentWarningsStatisticsParams(
          startDate: event.startDate!,
          endDate: event.endDate!,
          equipment: event.equipmentKey,
        ),
      );


      final statistics = statisticsResult.getOrElse(() => []);
      final workPercentage = percentResult.getOrElse(() => []);
      final equipmentPercent = equipmentPercentResult.fold((l) => null, (r) => r);
      final warningStatistics = warningStatisticsResult.fold((l) => null, (r) => r);

      if (statisticsResult.isLeft() ||
          percentResult.isLeft() ||
          equipmentPercentResult.isLeft() ||
          warningStatisticsResult.isLeft()) {
        emit(currentState.copyWith(
          message: BottomMessage("Не удалось загрузить данные", isError: true),
        ));
        return;
      }

      emit(currentState.copyWith(
        statistics: statistics,
        excessPercent: event.excessPercent,
        selectedEquipmentKey: Optional(event.equipmentKey),
        startDate: event.startDate,
        endDate: event.endDate,
        workPercentage: workPercentage,
        equipmentPercent: equipmentPercent,
        warningStatistics: warningStatistics,
      ));
    }
  }

  Future<void> _onSaveDateTimeRange(SaveDateTimeRange event, Emitter<StatisticsState> emit) async {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;

      final result = await saveTimeRange(DateTimeRange(start: event.startDate, end: event.endDate));

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage("Не удалось сохранить период", isError: true),
        )),
            (_) {
          emit(currentState.copyWith(
            startDate: event.startDate,
            endDate: event.endDate,
          ));
          _refetchStatistics(currentState.copyWith(
            startDate: event.startDate,
            endDate: event.endDate,
          ));
        },
      );
    }
  }

  Future<void> _onSaveExcessPercent(SaveExcessPercentEvent event, Emitter<StatisticsState> emit) async {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;

      final result = await saveExcessPercent(event.excessPercent);

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage("Не удалось сохранить процент превышения", isError: true),
        )),
            (_) {
          emit(currentState.copyWith(excessPercent: event.excessPercent));
          _refetchStatistics(currentState.copyWith(excessPercent: event.excessPercent));
        },
      );
    }
  }

  Future<void> _onSaveSelectedEquipment(SaveSelectedEquipmentEvent event, Emitter<StatisticsState> emit) async {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;

      final result = await saveSelectedEquipment(event.equipmentKey);

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage("Не удалось сохранить выбранное оборудование", isError: true),
        )),
            (_) {
          emit(currentState.copyWith(selectedEquipmentKey: Optional(event.equipmentKey)));
          _refetchStatistics(currentState.copyWith(selectedEquipmentKey: Optional(event.equipmentKey)));
        },
      );
    }
  }

  void _onUpdateGroupBy(UpdateGroupBy event, Emitter<StatisticsState> emit) {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;
      emit(currentState.copyWith(selectedGroupBy: event.groupBy));
      _refetchStatistics(currentState.copyWith(selectedGroupBy: event.groupBy));
    }
  }

  void _onUpdateMetric(UpdateMetric event, Emitter<StatisticsState> emit) {
    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;
      emit(currentState.copyWith(selectedMetric: event.metric));
      _refetchStatistics(currentState.copyWith(selectedMetric: event.metric));
    }
  }

  void _refetchStatistics(StatisticsLoaded currentState) {
    if (currentState.startDate != null &&
        currentState.endDate != null) {
      add(FetchStatistics(
        excessPercent: currentState.excessPercent,
        equipmentKey: currentState.selectedEquipmentKey,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
      ));
    }
  }
}