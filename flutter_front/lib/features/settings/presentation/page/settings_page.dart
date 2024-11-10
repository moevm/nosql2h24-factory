import 'package:clean_architecture/features/settings/presentation/widgets/import_export_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../locator_service.dart';
import '../../../../shared/presentation/responsive_scaffold.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
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
        if (state is SettingsLoaded && state.theme != null) {
          context.read<ThemeCubit>().toggleTheme(theme: state.theme!);
        }
        if (state is SettingsProcessing){
          const Center(child: CupertinoActivityIndicator());
        }
      },
      builder: (context, state) {
        return ResponsiveScaffold(
          title: 'Настройки',
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SettingsState state) {
    return switch (state) {
      SettingsLoaded() => _buildSettings(context, state),
      _ => const SizedBox(),
    };
  }

  Widget _buildSettings(BuildContext context, SettingsLoaded state) {
    return ListView(
      children: [
        ImportExport(
          title: "Импорт/экспорт настроек",
          children: [
            SettingsListTile(
              title: 'Export Settings',
              icon: Icons.upload,
              onTap: () {
                context.read<SettingsBloc>().add(ExportSettingsEvent());
              },
            ),
            SettingsListTile(
              title: 'Import Settings',
              icon: Icons.download,
              onTap: () {
                context.read<SettingsBloc>().add(ImportSettingsEvent());
              },
            ),
          ],
        ),
      ],
    );
  }
}