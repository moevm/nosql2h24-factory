import 'package:clean_architecture/features/settings/presentation/widgets/settings_message.dart';
import 'package:clean_architecture/features/warnings/domain/entities/description.dart';
import 'package:clean_architecture/features/warnings/domain/usecases/update_warning_description.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/domain/usecases/get_chosen_equipment.dart';
import '../../../../shared/domain/usecases/get_excess_percent.dart';
import '../../../../shared/domain/usecases/get_timerange.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../../../shared/domain/usecases/set_chosen_equipment.dart';
import '../../../../shared/domain/usecases/set_excess_percent.dart';
import '../../../../shared/domain/usecases/set_timerange.dart';
import '../../domain/entities/warning.dart';
import '../../domain/entities/warnings_data.dart';
import '../../domain/usecases/get_warnings_usecase.dart';
import '../../domain/repositories/warnings_repository.dart';
import '../../domain/usecases/warning_viewed_usecase.dart';

part 'warnings_event.dart';
part 'warnings_state.dart';

class WarningsBloc extends Bloc<WarningsEvent, WarningsState> {
  final GetWarningsUseCase getWarnings;
  final WarningViewedUseCase warningViewed;
  final UpdateWarningDescriptionUseCase updateWarningDescription;
  final HiveRepository repository;
  final GetTimeRangeUseCase getTimeRange;
  final SaveTimeRangeUseCase saveTimeRange;
  final GetExcessPercentUseCase getExcessPercent;
  final SetExcessPercentUseCase saveExcessPercent;
  final GetChosenEquipmentUseCase getSelectedEquipment;
  final SetChosenEquipmentUseCase saveSelectedEquipment;

  WarningsBloc({
    required this.getWarnings,
    required this.repository,
    required this.warningViewed,
    required this.updateWarningDescription,
    required this.getTimeRange,
    required this.saveTimeRange,
    required this.getExcessPercent,
    required this.saveExcessPercent,
    required this.getSelectedEquipment,
    required this.saveSelectedEquipment,
  }) : super(WarningsInitial()) {
    on<FetchWarnings>(_onFetchWarnings);
    on<InitializeWarnings>(_onInitializeWarnings);
    on<SaveDateTimeRange>(_onSaveDateTimeRange);
    on<MarkWarningAsViewed>(_onMarkWarningAsViewed);
    on<ToggleWarningViewed>(_onToggleWarningViewed);
    on<UpdateWarningDescription>(_onUpdateWarningDescription);
    on<SaveExcessPercentEvent>(_onSaveExcessPercent);
    on<SaveSelectedEquipmentEvent>(_onSaveSelectedEquipment);
  }


  Future<void> _onInitializeWarnings(InitializeWarnings event, Emitter<WarningsState> emit) async {
    emit(WarningsLoading());

    final dateTimeRangeResult = await getTimeRange(NoParams());
    final excessPercentResult = await getExcessPercent(NoParams());
    final selectedEquipmentResult = await getSelectedEquipment(NoParams());

    Either<Failure, double?> excessPercent = excessPercentResult;
    Either<Failure, String?> equipmentKey = selectedEquipmentResult;
    Either<Failure, DateTimeRange?> dateTimeRange = dateTimeRangeResult;

    if (excessPercent.isRight() && equipmentKey.isRight() && dateTimeRange.isRight()) {
      add(FetchWarnings(
        page: 1,
        excessPercent: excessPercent.fold((l) => 0, (r) => r ?? 0),
        equipmentKey: equipmentKey.fold((l) => null, (r) => r),
        startDate: dateTimeRange.fold((l) => null, (r) => r?.start),
        endDate: dateTimeRange.fold((l) => null, (r) => r?.end),
      ));
    }
  }

  Future<void> _onFetchWarnings(FetchWarnings event, Emitter<WarningsState> emit) async {
    final currentState = state;
    if (currentState is! WarningsLoaded) {
      emit(WarningsLoading());
    }

    final result = await getWarnings(GetWarningsUseCaseParams(
      page: event.page,
      excessPercent: event.excessPercent,
      equipmentKey: event.equipmentKey,
      startDate: event.startDate,
      endDate: event.endDate,
      orderAscending: event.orderAscending,
      withDescription: event.withDescription,
      viewed: event.viewed,
    ));

    result.fold(
          (failure) {
        if (currentState is WarningsLoaded) {
          emit(currentState.copyWith(
              message: BottomMessage('Failed to fetch warnings', isError: true)
          ));
        } else {
          emit(WarningsError("Не удается загрузить предупреждения"));
        }
      },
          (warningsData) => emit(WarningsLoaded(
        warningsData: warningsData,
        excessPercent: event.excessPercent,
        selectedEquipmentKey: event.equipmentKey,
        startDate: event.startDate,
        endDate: event.endDate,
        orderAscending: event.orderAscending,
        withDescription: event.withDescription,
        viewed: event.viewed,
      )),
    );
  }

  Future<void> _onSaveDateTimeRange(SaveDateTimeRange event, Emitter<WarningsState> emit) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

    final result = await repository.setDateTimeRange(DateTimeRange(start: event.startDate, end: event.endDate));

    result.fold(
          (failure) => emit(currentState.copyWith(
          message: BottomMessage('Failed to save date range', isError: true)
      )),
          (_) => add(FetchWarnings(
        page: 1,
        excessPercent: currentState.excessPercent,
        equipmentKey: currentState.selectedEquipmentKey,
        startDate: event.startDate,
        endDate: event.endDate,
      )),
    );
  }

  Future<void> _onSaveExcessPercent(SaveExcessPercentEvent event, Emitter<WarningsState> emit) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

    final result = await saveExcessPercent(event.excessPercent);

    result.fold(
          (failure) => emit(currentState.copyWith(
          message: BottomMessage('Не удалось сохранить процент превышения', isError: true)
      )),
          (_) => add(FetchWarnings(
        page: 1,
        excessPercent: event.excessPercent,
        equipmentKey: currentState.selectedEquipmentKey,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
      )),
    );
  }

  Future<void> _onSaveSelectedEquipment(SaveSelectedEquipmentEvent event, Emitter<WarningsState> emit) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

    final result = await saveSelectedEquipment(event.equipmentKey);

    result.fold(
          (failure) => emit(currentState.copyWith(
          message: BottomMessage('Не удалось сохранить выбранное оборудование', isError: true)
      )),
          (_) => add(FetchWarnings(
        page: 1,
        excessPercent: currentState.excessPercent,
        equipmentKey: event.equipmentKey,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
      )),
    );
  }

  Future<void> _onMarkWarningAsViewed(
      MarkWarningAsViewed event,
      Emitter<WarningsState> emit,
      ) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

    final result = await warningViewed(
        WarningViewedParams([event.warning], true)
    );

    result.fold(
          (failure) => emit(currentState.copyWith(
          message: BottomMessage('Failed to mark warning as viewed', isError: true)
      )),
          (_) {
        final updatedWarnings = currentState.warningsData.warnings.map((warning) {
          if (warning.id == event.warning.id) {
            return warning.copyWith(viewed: true);
          }
          return warning;
        }).toList();

        emit(currentState.copyWith(
          warningsData: currentState.warningsData.copyWith(
            warnings: updatedWarnings,
          ),
        ));
      },
    );
  }

  Future<void> _onToggleWarningViewed(
      ToggleWarningViewed event,
      Emitter<WarningsState> emit,
      ) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

    final result = await warningViewed(
        WarningViewedParams([event.warning], event.viewed)
    );

    result.fold(
          (failure) => emit(currentState.copyWith(
          message: BottomMessage('Failed to update warning status', isError: true)
      )),
          (_) {
        final updatedWarnings = currentState.warningsData.warnings.map((warning) {
          if (warning.id == event.warning.id) {
            return warning.copyWith(viewed: event.viewed);
          }
          return warning;
        }).toList();

        emit(currentState.copyWith(
          warningsData: currentState.warningsData.copyWith(
            warnings: updatedWarnings,
          ),
        ));
      },
    );
  }

  Future<void> _onUpdateWarningDescription(
      UpdateWarningDescription event,
      Emitter<WarningsState> emit,
      ) async {
    if (state is! WarningsLoaded) return;
    final currentState = state as WarningsLoaded;

      final descriptionRes = await updateWarningDescription(UpdateWarningDescriptionParams(event.text, event.warning.id));
      return descriptionRes.fold(
          (f) => emit(currentState.copyWith(
            message: BottomMessage('Не удалось обновить описание', isError: true),
          )),
          (description){
            final updatedWarnings = currentState.warningsData.warnings.map((warning) {
              if (warning.id == event.warning.id) {
                return warning.copyWith(description: description);
              }
              return warning;
            }).toList();

            emit(currentState.copyWith(
              warningsData: currentState.warningsData.copyWith(
                warnings: updatedWarnings,
              ),
              message: BottomMessage('Описание успешно обновлено', isError: false),
            ));
          }
      );
  }
}