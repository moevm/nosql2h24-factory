import 'dart:async';

import 'package:clean_architecture/features/charts/domain/usecases/get_charts_data_use_case.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:clean_architecture/shared/domain/usecases/get_multiple_chosen_equipment.dart';
import 'package:clean_architecture/shared/domain/usecases/set_multiple_chosen_equipment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/optional.dart';
import '../../../../shared/data/models/minichart_data_model.dart';
import '../../../../shared/domain/entities/equipment/equipment_list_entity.dart';
import '../../../../shared/domain/usecases/get_equipment_usecase.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../../settings/presentation/widgets/settings_message.dart';
import '../../domain/entities/chart_config.dart';

part 'charts_event.dart';
part 'charts_state.dart';

class ChartsBloc extends Bloc<ChartsEvent, ChartsState> {
  final GetEquipmentUseCase getEquipmentList;
  final GetMultipleChosenEquipmentUseCase getSelectedEquipment;
  final SetMultipleChosenEquipmentUseCase saveSelectedEquipment;
  final GetChartsDataUseCase getChartsDataUseCase;
  Timer? _realTimeTimer;

  ChartsBloc({
    required this.getEquipmentList,
    required this.getSelectedEquipment,
    required this.saveSelectedEquipment,
    required this.getChartsDataUseCase,
  }) : super(ChartsInitial()) {
    on<InitializeCharts>(_onInitializeCharts);
    on<SaveSelectedEquipmentEvent>(_onSaveSelectedEquipment);
    on<SaveSelectedParametersEvent>(_onSaveSelectedParameters);
    on<UpdateChartConfigurationEvent>(_onUpdateConfiguration);
    on<FetchChartsDataEvent>(_onFetchChartsData);
    on<FetchRealTimeDataEvent>(_onFetchRealTimeData);
  }

  @override
  Future<void> close() {
    _realTimeTimer?.cancel();
    return super.close();
  }


  Future<void> _onInitializeCharts(
      InitializeCharts event,
      Emitter<ChartsState> emit,
      ) async {
    emit(ChartsLoading());

    final selectedEquipmentResult = await getSelectedEquipment(NoParams());
    final equipmentListResult = await getEquipmentList(NoParams());

    selectedEquipmentResult.fold(
          (failure) => emit(ChartsError("Не удалось загрузить выбранное оборудование")),
          (selectedEquipment) async {
        equipmentListResult.fold(
              (failure) =>
              emit(ChartsError("Не удалось загрузить список оборудования")),
              (equipmentList) async {
            // Если нет сохраненного оборудования, устанавливаем значения по умолчанию
            if (selectedEquipment == null) {
              final defaultEquipment = ["gib2"];
              final saveResult = await saveSelectedEquipment(defaultEquipment);

              saveResult.fold(
                    (failure) => emit(ChartsError("Не удалось сохранить оборудование по умолчанию")),
                    (_) async {
                  final configuration = ChartConfiguration();
                  final loadedState = ChartsLoaded(
                    equipmentList: equipmentList,
                    selectedEquipmentKeys: defaultEquipment,
                    selectedParameterKeys: ["current", "total_power"],
                    configuration: configuration,
                  );
                  emit(loadedState);

                  // Запрашиваем данные после инициализации
                  add(FetchChartsDataEvent());
                },
              );
            } else {
              final configuration = ChartConfiguration();
              final loadedState = ChartsLoaded(
                equipmentList: equipmentList,
                selectedEquipmentKeys: selectedEquipment,
                selectedParameterKeys: ["current", "total_power"],
                configuration: configuration,
              );
              emit(loadedState);

              // Запрашиваем данные после инициализации
              add(FetchChartsDataEvent());
            }
          },
        );
      },
    );
  }

  Future<void> _onSaveSelectedEquipment(
      SaveSelectedEquipmentEvent event,
      Emitter<ChartsState> emit,
      ) async {
    if (state is ChartsLoaded) {
      final currentState = state as ChartsLoaded;
      emit(ChartsSavingEquipment(currentState));


      final result = await saveSelectedEquipment(event.equipmentKeys);

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage(
            "Не удалось сохранить выбранное оборудование",
            isError: true,
          ),
        )),
            (_) => emit(currentState.copyWith(
          selectedEquipmentKeys: Optional(event.equipmentKeys),
          selectedParameterKeys: const Optional(null), // Сбрасываем параметры при смене оборудования
        )),
      );
    }
  }

  void _onSaveSelectedParameters(
      SaveSelectedParametersEvent event,
      Emitter<ChartsState> emit,
      ) {
    if (state is ChartsLoaded) {
      final currentState = state as ChartsLoaded;
      emit(currentState.copyWith(
        selectedParameterKeys: Optional(event.parameterKeys),
      ));
    }
  }

  void _onUpdateConfiguration(
      UpdateChartConfigurationEvent event,
      Emitter<ChartsState> emit,
      ) {
    if (state is ChartsLoaded) {
      final currentState = state as ChartsLoaded;

      _realTimeTimer?.cancel();

      if (event.configuration.realTime) {
        _realTimeTimer = Timer.periodic(
          event.configuration.pointsDistance,
              (_) => add(FetchRealTimeDataEvent()),
        );
      }

      emit(currentState.copyWith(configuration: event.configuration));
    }
  }


  Future<void> _onFetchChartsData(
      FetchChartsDataEvent event,
      Emitter<ChartsState> emit,
      ) async {
    if (state is ChartsLoaded) {
      final currentState = state as ChartsLoaded;
      emit(ChartsFetchingData(currentState));

      final topics = _getFetchTopics(currentState);
      final now = DateTime.now();
      final params = GetChartsDataUseCaseParams(
        period: currentState.configuration.timeRange,
        start: currentState.configuration.customStartDate ?? now,
        end: currentState.configuration.customEndDate ?? now,
        interval: currentState.configuration.pointsDistance,
        topics: topics,
      );

      final result = await getChartsDataUseCase(params);

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage(
            "Не удалось получить данные графиков",
            isError: true,
          ),
        )),
            (data) {
          emit(currentState.copyWith(
            chartData: data,
            message: BottomMessage("Данные успешно получены"),
          ));
        },
      );
    }
  }

  Future<void> _onFetchRealTimeData(
      FetchRealTimeDataEvent event,
      Emitter<ChartsState> emit,
      ) async {
    if (state is ChartsLoaded) {
      final currentState = state as ChartsLoaded;

      final topics = _getFetchTopics(currentState);
      final now = DateTime.now();
      final params = GetChartsDataUseCaseParams(
        period: TimeRange.custom,
        start: now.subtract(currentState.configuration.pointsDistance),
        end: now,
        interval: currentState.configuration.pointsDistance,
        topics: topics,
      );

      final result = await getChartsDataUseCase(params);

      result.fold(
            (failure) => emit(currentState.copyWith(
          message: BottomMessage(
            "Не удалось получить данные в реальном времени",
            isError: true,
          ),
        )),
            (newData) {
          final updatedChartData = _updateRealTimeData(currentState.chartData, newData);
          emit(currentState.copyWith(chartData: updatedChartData));
        },
      );
    }
  }

  MiniChartDataModel? _updateRealTimeData(
      MiniChartDataModel? currentData,
      MiniChartDataModel newData,
      ) {
    if (currentData == null) return newData;

    Map<String, Map<String, Map<String, List<ChartDataPoint>>>> updatedData = {};

    currentData.data.forEach((equipKey, equipValue) {
      updatedData[equipKey] = {};

      equipValue.forEach((paramKey, paramValue) {
        updatedData[equipKey]![paramKey] = {};

        paramValue.forEach((subParamKey, points) {
          if (points != null) {
            var newPoints = List<ChartDataPoint>.from(points);

            // Добавляем новую точку и удаляем первую
            if (newData.data[equipKey]?[paramKey]?[subParamKey]?.isNotEmpty ?? false) {
              newPoints.removeAt(0);
              newPoints.add(newData.data[equipKey]![paramKey]![subParamKey]!.first);
            }

            updatedData[equipKey]![paramKey]![subParamKey] = newPoints;
          }
        });
      });
    });

    return MiniChartDataModel(updatedData);
  }

  Map<String, dynamic> _getFetchTopics(ChartsLoaded state){
    Map<String, dynamic> topics = {};
    if(state.selectedEquipmentKeys != null && state.selectedParameterKeys != null) {
      for (String equipKey in state.selectedEquipmentKeys!) {
        EquipmentEntity equipment = state.equipmentList.equipment.firstWhere((e) => e.key==equipKey);
        topics[equipKey] = {};
        for(String paramKey in state.selectedParameterKeys!){
          topics[equipKey][paramKey] = [];
          if(equipment.parameters[paramKey] != null) {
            for (var topic in equipment.parameters[paramKey]!.subparameters.entries) {
              topics[equipKey][paramKey].add(topic.key);
            }
          }
        }
      }
    }
    return topics;
  }
}