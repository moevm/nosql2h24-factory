import 'package:flutter/material.dart';

import '../../../home/domain/entities/fetch_topics.dart';

class SettingsEntity {
  final ThemeMode? theme;
  final FetchMiniChartsTopics? miniChartsTopics;
  final List<String>? collapsedEquipment;

  SettingsEntity({
    this.theme,
    this.miniChartsTopics,
    this.collapsedEquipment
  });
}