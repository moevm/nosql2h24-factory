import 'dart:async';

import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/services/equipment_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';

import '../../../../shared/data/models/minichart_data_model.dart';
import '../../../../shared/domain/entities/equipment/equipment_entity.dart';
import '../../domain/usecases/get_collapsed_equipment_usecase.dart';
import '../../domain/usecases/init_chart_data.dart';
import '../../domain/usecases/open_page_usecase.dart';
import '../../domain/usecases/save_collapsed_equipment_usecase.dart';
import '../../domain/usecases/update_chart.dart';
import '../../domain/usecases/update_minichart_settings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomePageDataUseCase getHomePageDataUseCase;
  final InitializeChartDataUseCase initializeChartDataUseCase;
  final UpdateChartDataUseCase updateChartDataUseCase;
  final UpdateMiniChartSettingsUseCase updateMiniChartSettingsUseCase;
  final GetCollapsedEquipmentUseCase getCollapsedEquipmentUseCase;
  final SaveCollapsedEquipmentUseCase saveCollapsedEquipmentUseCase;
  final Duration interval = const Duration(seconds: 3);
  Timer? _updateTimer;
  List<String> _lastCollapsedList = [];

  HomeBloc({
    required this.getHomePageDataUseCase,
    required this.initializeChartDataUseCase,
    required this.updateChartDataUseCase,
    required this.updateMiniChartSettingsUseCase,
    required this.getCollapsedEquipmentUseCase,
    required this.saveCollapsedEquipmentUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomePage>(_onLoadHomePage);
    on<UpdateChartData>(_onUpdateChartData);
    on<UpdateChartSettings>(_onUpdateChartSettings);
    on<ToggleEquipmentCollapse>(_onToggleEquipmentCollapse);
  }

  void _onLoadHomePage(LoadHomePage event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomePageDataUseCase(NoParams());

    await result.fold(
            (failure) async {
          emit(HomeError('Failed to load home page data: ${failure.toString()}'));
        },
            (data) async {
          final settings = await initializeChartDataUseCase(data.equipment);

          await settings.fold(
                  (failure) async {
                emit(HomeError('Failed to initialize chart data: ${failure.toString()}'));
              },
                  (chartData) async {
                final collapsedRes = await getCollapsedEquipmentUseCase(NoParams());

                await collapsedRes.fold(
                        (failure) async {
                      emit(HomeError('Failed to get Collapsed Equipment: ${failure.toString()}'));
                    },
                        (collapsed) {
                          _lastCollapsedList = collapsed;
                      emit(_createHomeLoadedState(
                        data.equipment,
                        chartData,
                        data.logo,
                        collapsedEquipment: collapsed,
                      ));
                    }
                );
              }
          );
        }
    );

    _startUpdateTimer();
  }

  void _onUpdateChartData(UpdateChartData event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final result = await updateChartDataUseCase(
          InitChartData(currentState.charts, currentState.settings)
      );
      result.fold(
            (failure) => emit(HomeError('Failed to update chart data: ${failure.toString()}')),
            (updatedChartData) {
          emit(_createHomeLoadedState(
            currentState.equipment,
            updatedChartData,
            currentState.logo,
            collapsedEquipment: _lastCollapsedList,
          ));
        },
      );
    }
  }

  void _onUpdateChartSettings(UpdateChartSettings event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoading());
      final result = await updateMiniChartSettingsUseCase(
          UpdateMiniChartSettingsParams(
              event.newSettings,
              currentState.equipment,
              currentState.settings
          )
      );
      result.fold(
              (failure) => emit(HomeError('Failed to update chart data: ${failure.toString()}')),
              (updatedChartData) {
            emit(_createHomeLoadedState(
              currentState.equipment,
              updatedChartData,
              currentState.logo,
              collapsedEquipment: currentState.collapsedEquipment,
            ));
          }
      );
    }
  }

  void _onToggleEquipmentCollapse(ToggleEquipmentCollapse event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<String> newCollapsedList = List.from(currentState.collapsedEquipment);

      if (newCollapsedList.contains(event.equipmentKey)) {
        newCollapsedList.remove(event.equipmentKey);
      } else {
        newCollapsedList.add(event.equipmentKey);
      }

      _lastCollapsedList = newCollapsedList;

      // Эмитим новое состояние немедленно
      emit(HomeLoaded(
        currentState.logo,
        currentState.equipment,
        currentState.charts,
        currentState.settings,
        currentState.statuses,
        currentState.workNum,
        currentState.maxTemperature,
        collapsedEquipment: newCollapsedList,
      ));

      final saveResult = await saveCollapsedEquipmentUseCase(newCollapsedList);

      saveResult.fold(
              (failure) => emit(HomeError('Failed to save collapsed equipment: ${failure.toString()}')),
              (_) {} // Ничего не делаем при успешном сохранении, так как состояние уже обновлено
      );
    }
  }

  Map<String, EquipmentStatus> _getStatuses(
      EquipmentListEntity equipment,
      MiniChartDataModel chartData
      ) {
    int workNum = 0;
    final statuses = Map.fromEntries(equipment.equipment.map((equip) {
      if (equip.workingParameter == null) {
        return MapEntry(equip.key, EquipmentStatus.turnOn);
      }

      final param = equip.workingParameter!.name;
      final lastValue = chartData.data[equip.key]?[param]?[param]?.last.value;

      if (lastValue == null) {
        return MapEntry(equip.key, EquipmentStatus.notWork);
      }
      if (lastValue == 0) return MapEntry(equip.key, EquipmentStatus.turnOff);
      if (lastValue > equip.workingParameter!.threshold) {
        workNum++;
        return MapEntry(equip.key, EquipmentStatus.work);
      }
      return MapEntry(equip.key, EquipmentStatus.turnOn);
    }));

    return statuses;
  }

  double? _getMaxTemperature(InitChartData data) {
    double? maxTemperature;
    for (var equipMap in data.data.data.values) {
      final temperatureOut = equipMap["temperature"]?["temperature_out"];
      if(temperatureOut != null) {
        if (temperatureOut.isNotEmpty) {
          final lastTemp = temperatureOut.last.value;
          if (maxTemperature == null || lastTemp > maxTemperature) {
            maxTemperature = lastTemp.toDouble();
          }
        }
      }
    }
    return maxTemperature;
  }

  HomeLoaded _createHomeLoadedState(
      EquipmentListEntity equipment,
      InitChartData chartData,
      String? logo, {
        List<String>? collapsedEquipment,
      }) {
    final statuses = _getStatuses(equipment, chartData.data);
    final maxTemperature = _getMaxTemperature(chartData);
    final workNum = statuses.values.where((status) => status == EquipmentStatus.work).length;

    return HomeLoaded(
      logo,
      equipment,
      chartData.data,
      chartData.settings,
      statuses,
      workNum,
      maxTemperature,
      collapsedEquipment: collapsedEquipment ?? _lastCollapsedList,
    );
  }

  void _startUpdateTimer() {
    _stopUpdateTimer();
    _updateTimer = Timer.periodic(interval, (_) {
      if(!isClosed){
        add(UpdateChartData());
      }
    });
  }

  void _stopUpdateTimer() {
    _updateTimer?.cancel();
  }

  @override
  Future<void> close() {
    _stopUpdateTimer();
    return super.close();
  }
}