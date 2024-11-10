// home_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator_service.dart';
import '../../../../shared/presentation/org_logo.dart';
import '../../../../shared/presentation/responsive_scaffold.dart';
import '../bloc/home_bloc.dart';
import '../widgets/equipment_cards.dart';
import '../widgets/equipment_summary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(LoadHomePage()),
      child: const ResponsiveScaffold(
        title: "Главная страница",
        body: HomePageContent(),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocSelector<HomeBloc, HomeState, String?>(
            selector: (state) => state is HomeLoaded ? state.logo : null,
            builder: (context, logo) {
              return logo != null
                  ? RepaintBoundary(
                child: LogoImage(
                  key: ValueKey(logo),
                  logoBase64: logo,
                  width: 200,
                  height: 120,
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is HomeLoaded) {
                return Column(
                  children: [
                    EquipmentSummary(
                      workingEquipmentCount: state.workNum,
                      maxTemperature: state.maxTemperature,
                    ),
                    const SizedBox(height: 20),
                    EquipmentWidgetList(
                      equipmentList: state.equipment,
                      chartsData: state.charts,
                      statuses: state.statuses,
                    ),
                  ],
                );
              } else if (state is HomeError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Произошла неизвестная ошибка'));
              }
            },
          ),
        ],
      ),
    );
  }
}