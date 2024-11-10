import 'package:clean_architecture/features/warnings/presentation/widgets/warning_list_item.dart';
import 'package:flutter/material.dart';

import '../../../../shared/presentation/fade_in_wrapper.dart';
import '../../domain/entities/warning.dart';

class WarningList extends StatelessWidget {
  final List<Warning> warnings;

  const WarningList({super.key, required this.warnings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800, // Максимальная ширина списка
              maxHeight: constraints.maxHeight,
            ),
            child: ListView.builder(
              itemCount: warnings.length,
              itemBuilder: (context, index) {
                return FadeInWrapper(
                  delayIndex: index,
                  child: WarningListItem(warning: warnings[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}