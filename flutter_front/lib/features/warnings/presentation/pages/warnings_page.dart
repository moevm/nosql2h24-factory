import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator_service.dart';
import '../../../../shared/presentation/responsive_scaffold.dart';
import '../bloc/warnings_bloc.dart';
import '../widgets/control_panel.dart';
import '../widgets/warnings_list.dart';

class WarningsPage extends StatefulWidget {
  const WarningsPage({super.key});

  @override
  _WarningsPageState createState() => _WarningsPageState();
}

class _WarningsPageState extends State<WarningsPage> {
  bool _isControlPanelExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: "Предупреждения",
      body: BlocProvider(
        create: (_) => getIt<WarningsBloc>()..add(InitializeWarnings()),
        child: BlocListener<WarningsBloc, WarningsState>(
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
          child: BlocBuilder<WarningsBloc, WarningsState>(
            buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType ||
                (current is WarningsLoaded && previous is WarningsLoaded &&
                    (current.warningsData != previous.warningsData ||
                        current.excessPercent != previous.excessPercent ||
                        current.selectedEquipmentKey != previous.selectedEquipmentKey ||
                        current.startDate != previous.startDate ||
                        current.endDate != previous.endDate ||
                        current.warningsData.warnings != previous.warningsData.warnings
                    )),
            builder: (context, state) {
              if (state is WarningsInitial || state is WarningsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WarningsLoaded) {
                return Column(
                  children: [
                    _buildControlPanelToggle(),
                    if (_isControlPanelExpanded)
                      WarningsControlPanel(
                        state: state,
                        isExpanded: _isControlPanelExpanded,
                      ),
                    Expanded(
                      child: WarningList(warnings: state.warningsData.warnings),
                    ),
                  ],
                );
              } else if (state is WarningsError){
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
        if (constraints.maxWidth >= 600) return const SizedBox.shrink();
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