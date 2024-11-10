// charts_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator_service.dart';
import '../../../../shared/presentation/responsive_scaffold.dart';
import '../../domain/entities/chart_config.dart';
import '../bloc/charts_bloc.dart';
import '../widgets/charts_grid.dart';
import '../widgets/control_panel.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: "Графики",
      body: BlocProvider(
        create: (_) => getIt<ChartsBloc>()..add(InitializeCharts()),
        child: BlocListener<ChartsBloc, ChartsState>(
          listenWhen: (previous, current) => current.message != null,
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 500),
                  content: Text(state.message!.message),
                  backgroundColor:
                  state.message!.isError ? Colors.red : Colors.green,
                ),
              );
            }
          },
          child: BlocBuilder<ChartsBloc, ChartsState>(
            builder: (context, state) {
              if (state is ChartsInitial || state is ChartsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is ChartsSavingEquipment) {
                return Stack(
                  children: [
                    _buildContent(context, state.previousState),
                    const Center(child: CupertinoActivityIndicator()),
                  ],
                );
              } else if (state is ChartsFetchingData) {
                return Stack(
                  children: [
                    _buildContent(context, state.previousState),
                    const Center(child: CupertinoActivityIndicator()),
                  ],
                );
              } else if (state is ChartsLoaded) {
                return _buildContent(context, state);
              } else if (state is ChartsError) {
                return Center(child: Text(state.errorMessage));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChartsLoaded state) {
    return Column(
      children: [
        ChartsControlPanel(
          equipmentList: state.equipmentList,
          selectedEquipmentKeys: state.selectedEquipmentKeys,
          selectedParameterKeys: state.selectedParameterKeys,
          configuration: state.configuration,
          onEquipmentChanged: (selectedKeys) {
            context.read<ChartsBloc>().add(
              SaveSelectedEquipmentEvent(equipmentKeys: selectedKeys),
            );
          },
          onParametersChanged: (selectedKeys) {
            context.read<ChartsBloc>().add(
              SaveSelectedParametersEvent(parameterKeys: selectedKeys),
            );
          },
          onConfigurationChanged: (config) {
            context.read<ChartsBloc>().add(
              UpdateChartConfigurationEvent(config),
            );
          },
          onFetchData: () {
            context.read<ChartsBloc>().add(FetchChartsDataEvent());
          },
        ),
        Expanded(
          child: state.chartData != null
              ? ChartsGrid(chartData: state.chartData!)
              : const Center(
            child: Text("Нажмите 'Получить данные' для отображения графиков"),
          ),
        ),
      ],
    );
  }
}