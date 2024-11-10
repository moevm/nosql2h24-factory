import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/settings_entity.dart';

class SettingsModel {
  final String? theme;
  final Map<String, dynamic>? miniChartsTopic;
  final List<String>? collapsedEquipment;

  SettingsModel({
    this.theme,
    this.miniChartsTopic,
    this.collapsedEquipment,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      theme: json['theme'],
      miniChartsTopic: json['mini_charts_topic'],
      collapsedEquipment: (json['collapsed_equipment'] as List<dynamic>).cast<String>(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'mini_charts_topic': miniChartsTopic,
      'collapsed_equipment': collapsedEquipment
    };
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
        theme: theme == "light" ? ThemeMode.light : (theme == "dark" ? ThemeMode.dark : null),
        miniChartsTopics: miniChartsTopic != null ? FetchMiniChartsTopics.fromMap(miniChartsTopic!) : null,
        collapsedEquipment: collapsedEquipment
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
        theme: entity.theme == ThemeMode.light ? "light" : (entity.theme == ThemeMode.dark ? "dark" : null),
        miniChartsTopic: entity.miniChartsTopics?.toMap(),
        collapsedEquipment: entity.collapsedEquipment
    );
  }
}