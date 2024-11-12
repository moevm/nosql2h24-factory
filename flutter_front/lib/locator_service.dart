import 'package:clean_architecture/features/charts/presentation/bloc/charts_bloc.dart';
import 'package:clean_architecture/features/login/data/repositories/auth_repository_impl.dart';
import 'package:clean_architecture/features/login/domain/repositories/auth_repository.dart';
import 'package:clean_architecture/features/settings/data/datasorces/settings_remote_data_source.dart';
import 'package:clean_architecture/features/settings/domain/usecases/export_settings_usecase.dart';
import 'package:clean_architecture/features/settings/domain/usecases/import_settings_usecase.dart';
import 'package:clean_architecture/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:clean_architecture/features/splash/data/datasources/users_local_data_source.dart';
import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:clean_architecture/features/splash/domain/usecases/check_auth_status_usecase.dart';
import 'package:clean_architecture/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:clean_architecture/features/statistics/domain/usecases/get_warning_statistics_usecase.dart';
import 'package:clean_architecture/features/warnings/data/datasources/warnings_remote_datasource.dart';
import 'package:clean_architecture/features/warnings/data/repositories/warnings_repository_impl.dart';
import 'package:clean_architecture/features/warnings/domain/repositories/warnings_repository.dart';
import 'package:clean_architecture/features/warnings/domain/usecases/get_warnings_usecase.dart';
import 'package:clean_architecture/features/warnings/presentation/bloc/warnings_bloc.dart';
import 'package:clean_architecture/shared/data/datasources/remote/influxdb_parser_datasource.dart';
import 'package:clean_architecture/shared/data/repositories/equipment_repository_impl.dart';
import 'package:clean_architecture/shared/data/repositories/hive_repository_impl.dart';
import 'package:clean_architecture/shared/data/repositories/influxdb_repository_impl.dart';
import 'package:clean_architecture/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:clean_architecture/shared/domain/repositories/equipment_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/influxdb_repository.dart';
import 'package:clean_architecture/shared/data/datasources/local/hive_datasource.dart';
import 'package:clean_architecture/shared/data/datasources/remote/equipment_datasource.dart';
import 'package:clean_architecture/features/settings/domain/repositories/settings_repository.dart';
import 'package:clean_architecture/shared/domain/usecases/get_chosen_equipment.dart';
import 'package:clean_architecture/shared/domain/usecases/get_equipment_usecase.dart';
import 'package:clean_architecture/shared/domain/usecases/get_excess_percent.dart';
import 'package:clean_architecture/shared/domain/usecases/get_multiple_chosen_equipment.dart';
import 'package:clean_architecture/shared/domain/usecases/get_theme_usecase.dart';
import 'package:clean_architecture/shared/domain/usecases/get_timerange.dart';
import 'package:clean_architecture/shared/domain/usecases/set_chosen_equipment.dart';
import 'package:clean_architecture/shared/domain/usecases/set_excess_percent.dart';
import 'package:clean_architecture/shared/domain/usecases/set_multiple_chosen_equipment.dart';
import 'package:clean_architecture/shared/domain/usecases/set_timerange.dart';
import 'package:clean_architecture/shared/domain/usecases/toggle_theme_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../features/login/data/datasources/auth_remote_data_source.dart';
import '../features/login/domain/usecases/login_usecase.dart';
import '../features/login/presentation/bloc/login_bloc.dart';
import 'core/http/api_client.dart';
import 'core/navigation/destinations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'features/charts/domain/usecases/get_charts_data_use_case.dart';
import 'features/home/domain/usecases/get_collapsed_equipment_usecase.dart';
import 'features/home/domain/usecases/init_chart_data.dart';
import 'features/home/domain/usecases/open_page_usecase.dart';
import 'features/home/domain/usecases/save_collapsed_equipment_usecase.dart';
import 'features/home/domain/usecases/update_chart.dart';
import 'features/home/domain/usecases/update_minichart_settings.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/splash/domain/usecases/entry_usecase.dart';
import 'features/splash/domain/usecases/logout_usecase.dart';
import 'features/statistics/data/data_source/statistics_datasource.dart';
import 'features/statistics/data/repository/statistics_repository_impl.dart';
import 'features/statistics/domain/repositories/statistics_repository.dart';
import 'features/statistics/domain/usecases/get_equipment_warnings_statistics.dart';
import 'features/statistics/domain/usecases/get_equipment_working_percentage.dart';
import 'features/statistics/domain/usecases/get_statistic_working_percentage.dart';
import 'features/statistics/presentation/bloc/statistics_bloc.dart';
import 'features/warnings/domain/usecases/update_warning_description.dart';
import 'features/warnings/domain/usecases/warning_viewed_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // BLoC

  getIt.registerFactory(
    () => LoginBloc(loginUseCase: getIt()),
  );

  getIt.registerFactory(
    () => HomeBloc(
      getHomePageDataUseCase: getIt(),
      initializeChartDataUseCase: getIt(),
      updateChartDataUseCase: getIt(),
      updateMiniChartSettingsUseCase: getIt(),
      getCollapsedEquipmentUseCase: getIt(),
      saveCollapsedEquipmentUseCase: getIt(),
    ),
  );

  getIt.registerFactory(() => WarningsBloc(
    getWarnings: getIt(),
    repository: getIt(),
    warningViewed: getIt(),
    updateWarningDescription: getIt(),
    getTimeRange: getIt(),
    saveTimeRange: getIt(),
    getExcessPercent: getIt(),
    saveExcessPercent: getIt(),
    getSelectedEquipment: getIt(),
    saveSelectedEquipment: getIt(),
  ));

  getIt.registerFactory(() => StatisticsBloc(
    getTimeRange: getIt(),
    saveTimeRange: getIt(),
    getExcessPercent: getIt(),
    saveExcessPercent: getIt(),
    getSelectedEquipment: getIt(),
    saveSelectedEquipment: getIt(),
    getEquipmentList: getIt(),
    getWarningStatistics: getIt(),
    getStatisticWorkingPercentage: getIt(),
    getEquipmentWorkingPercentage: getIt(),
    getEquipmentWarningsStatistics: getIt(),
  ));

  getIt.registerFactory(() => SplashBloc(
        checkAuthStatusUseCase: getIt(),
        entryUseCase: getIt(),
        getThemeUseCase: getIt(),
      ));

  getIt.registerFactory(
      () => SettingsBloc(exportSettings: getIt(), importSettings: getIt()));

  getIt.registerFactory(
          () => ChartsBloc(
              getEquipmentList: getIt(),
              getSelectedEquipment: getIt(),
              saveSelectedEquipment: getIt(),
              getChartsDataUseCase: getIt(),
          ));

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(
      loginRepository: getIt(),
      hiveRepository: getIt(),
      splashRepository: getIt()));
  getIt.registerLazySingleton(() => GetHomePageDataUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(
      () => InitializeChartDataUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(
      () => UpdateMiniChartSettingsUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => UpdateChartDataUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWarningsUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => ToggleThemeUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => EntryUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetThemeUseCase(getIt()));
  getIt.registerLazySingleton(() => ImportSettingsUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => ExportSettingsUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => WarningViewedUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCollapsedEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveCollapsedEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => SetChosenEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetChosenEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => SetExcessPercentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetExcessPercentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTimeRangeUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveTimeRangeUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateWarningDescriptionUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWarningStatisticsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetStatisticWorkingPercentageUseCase(getIt()));
  getIt.registerLazySingleton(() => GetEquipmentWorkingPercentage(getIt()));
  getIt.registerLazySingleton(() => GetEquipmentWarningsStatistics(getIt()));
  getIt.registerLazySingleton(() => GetMultipleChosenEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => SetMultipleChosenEquipmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetChartsDataUseCase(getIt()));

  // Repository

  getIt.registerLazySingleton<EquipmentRepository>(
      () => EquipmentRepositoryImpl(remoteDatasource: getIt()));

  getIt.registerLazySingleton<InfluxdbRepository>(
      () => InfluxdbRepositoryImpl(remoteDataSource: getIt()));

  getIt.registerLazySingleton<WarningsRepository>(
      () => WarningsRepositoryImpl(remoteDataSource: getIt()));

  getIt.registerLazySingleton<HiveRepository>(
      () => HiveRepositoryImpl(localDataSource: getIt()));

  getIt.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(remoteDataSource: getIt(), usersDataSource: getIt()));

  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
      localDataSource: getIt(), remoteDataSource: getIt()));

  getIt.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(usersDataSource: getIt()));

  getIt.registerLazySingleton<StatisticsRepository>(
          () => StatisticsRepositoryImpl(datasource: getIt()));

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<HiveLocalDataSource>(
    () => HiveLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<EquipmentRemoteDataSource>(
      () => EquipmentRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<InfluxdbParserRemoteDataSource>(
      () => InfluxdbParserRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<WarningsRemoteDataSource>(
      () => WarningsRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<UsersLocalDataSource>(
      () => UsersLocalDataSourceImpl());

  getIt.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<StatisticsDatasource>(
          () => StatisticsDatasourceImpl(client: getIt()));

  // Core
  getIt.registerLazySingleton<AppRoutes>(() => AppRoutes());

  getIt.registerSingleton<GoRouter>(
      GoRouter(routes: getIt<AppRoutes>().goRouterList));

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit(
        lightTheme: LightTheme(),
        darkTheme: DarkTheme(),
        toggleThemeUseCase: getIt(),
      ));

  getIt.registerLazySingleton(() => ApiClient(
        baseUrl: 'http://127.0.0.1:8080',
        hiveRepository: getIt(),
        logoutUseCase: getIt(),
      ));

  // External
  getIt.registerLazySingleton(() => http.Client());
}
