import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator_service.dart';
import '../../../../shared/presentation/responsive_scaffold.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/control_panel.dart';
import '../widgets/equipment_card.dart';
import '../widgets/static_selectors.dart';
import '../widgets/statistics_charts/statistics_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool _isControlPanelExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: "Статистика",
      body: BlocProvider(
        create: (_) => getIt<StatisticsBloc>()..add(InitializeStatistics()),
        child: BlocListener<StatisticsBloc, StatisticsState>(
          listenWhen: (previous, current) => current.message != null,
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 500),
                  content: Text(state.message!.message),
                  backgroundColor: state.message!.isError ? Colors.red : Colors.green,
                ),
              );
            }
          },
          child: BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              if (state is StatisticsInitial || state is StatisticsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is StatisticsFetching) {
                return Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: 0.5, // Уменьшаем прозрачность контента при загрузке
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          _buildControlPanelToggle(),
                          if (_isControlPanelExpanded)
                            StatisticsControlPanel(
                              state: state.lastState,
                              isExpanded: _isControlPanelExpanded,
                            ),
                          StatisticsSelectors(
                            selectedGroupBy: state.lastState.selectedGroupBy,
                            selectedMetric: state.lastState.selectedMetric,
                            onGroupByChanged: (groupBy) {
                              context.read<StatisticsBloc>().add(UpdateGroupBy(groupBy: groupBy));
                            },
                            onMetricChanged: (metric) {
                              context.read<StatisticsBloc>().add(UpdateMetric(metric: metric));
                            },
                          ),
                          Expanded(
                            child: StatisticsChart(
                              statistics: state.lastState.statistics,
                              metric: state.lastState.selectedMetric,
                              workPercentage: state.lastState.workPercentage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ],
                );
              } else if (state is StatisticsLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildControlPanelToggle(),
                      if (_isControlPanelExpanded)
                        StatisticsControlPanel(
                          state: state,
                          isExpanded: _isControlPanelExpanded,
                        ),
                      StatisticsSelectors(
                        selectedGroupBy: state.selectedGroupBy,
                        selectedMetric: state.selectedMetric,
                        onGroupByChanged: (groupBy) {
                          context.read<StatisticsBloc>().add(UpdateGroupBy(groupBy: groupBy));
                        },
                        onMetricChanged: (metric) {
                          context.read<StatisticsBloc>().add(UpdateMetric(metric: metric));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: WorkingPercentageCard(
                          percentages: state.equipmentPercent,
                          equipmentName: state.equipmentList.getKeysAndNames()[state.selectedEquipmentKey],
                          warnings: state.warningStatistics,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: StatisticsChart(
                          statistics: state.statistics,
                          metric: state.selectedMetric,
                          workPercentage: state.workPercentage,
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is StatisticsError) {
                return Center(child: Text(state.errorMessage));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanelToggle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          _isControlPanelExpanded = true;
          return const SizedBox.shrink();
        }
        return IconButton(
          icon: Icon(_isControlPanelExpanded ? Icons.expand_less : Icons.expand_more),
          onPressed: () {
            setState(() {
              _isControlPanelExpanded = !_isControlPanelExpanded;
            });
          },
        );
      },
    );
  }
}