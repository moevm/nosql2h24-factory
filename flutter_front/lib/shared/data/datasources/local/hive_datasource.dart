import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../features/charts/domain/entities/chart_config.dart';

abstract class HiveLocalDataSource {
  Future<void> initializeUserBox(String username);
  Future<void> saveUsername(String username);
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> saveLogo(String logo);
  Future<void> saveTheme(String theme);
  Future<void> saveMiniChartsTopics(FetchMiniChartsTopics topics);

  Future<String?> getLogo();
  Future<String?> getUsername();

  Future<String?> getToken();
  Future<String?> getTheme();
  Future<String?> getRefreshToken();
  Future<FetchMiniChartsTopics?> getMiniChartsTopics();

  Future<DateTimeRange> getPeriod();
  Future<void> savePeriod(DateTimeRange period);

  Future<List<String>> getCollapsedEquipment();
  Future<void> saveCollapsedEquipment(List<String> collapsedKeys);

  Future<String?> getChosenEquipment();
  Future<void> saveChosenEquipment(String? equipment);

  Future<double?> getExcessPercent();
  Future<void> saveExcessPercent(double percent);

  Future<List<String>?> getMultipleChosenEquipment();
  Future<void> saveMultipleChosenEquipment(List<String>? equipment);

  // Future<ChartConfiguration?> getChartsConfiguration();
  // Future<void> saveChartsConfiguration(Map<String, dynamic> config);
  //
  // Future<ChartsLayoutData?> getChartsLayout();
  // Future<void> saveChartsLayout(Map<String, dynamic> data);
}

class HiveLocalDataSourceImpl implements HiveLocalDataSource {
  static const String SESSION_BOX_NAME = 'session';
  static const String CURRENT_USER_KEY = 'current_username';

  Box? _userBox;
  Box? _sessionBox;

  Future<Box> get sessionBox async {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      _sessionBox = await Hive.openBox(SESSION_BOX_NAME);
    }
    return _sessionBox!;
  }

  Future<Box> get getUserBox async {
    if (_userBox == null || !_userBox!.isOpen) {
      final session = await sessionBox;
      final username = session.get(CURRENT_USER_KEY) as String?;
      if (username == null) {
        throw Exception('Username not set. Call initializeUserBox first');
      }
      _userBox = await Hive.openBox('user_$username');
    }
    return _userBox!;
  }

  @override
  Future<void> initializeUserBox(String username) async {
    if (_userBox != null && _userBox!.isOpen) {
      await _userBox!.close();
    }

    final session = await sessionBox;
    await session.put(CURRENT_USER_KEY, username);

    _userBox = await Hive.openBox('user_$username');
  }


  @override
  Future<void> saveUsername(String username) async {
    final userBox = await getUserBox;
    await userBox.put("username", {"value": username});
  }

  @override
  Future<void> saveToken(String token) async {
    final userBox = await getUserBox;
    await userBox.put("token", {"value": token});
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    final userBox = await getUserBox;
    await userBox.put("refreshToken", {"value": token});
  }

  @override
  Future<void> saveLogo(String logo) async {
    final userBox = await getUserBox;
    await userBox.put("logo", <String, dynamic>{"value": logo});
  }

  @override
  Future<String?> getLogo() async {
    final userBox = await getUserBox;
    final logo = userBox.get("logo") as Map?;
    return logo?["value"] as String?;
  }

  @override
  Future<String?> getUsername() async {
    final userBox = await getUserBox;
    final username = userBox.get("username");
    return username?["value"] as String?;
  }

  @override
  Future<String?> getToken() async {
    try {
      final userBox = await getUserBox;
      final token = userBox.get("token") as Map?;
      return token?["value"] as String?;
    } catch (e){
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    final userBox = await getUserBox;
    final token = userBox.get("refreshToken") as Map?;
    return token?["value"] as String?;
  }


  @override
  Future<void> saveMiniChartsTopics(FetchMiniChartsTopics topics) async {
    final userBox = await getUserBox;
    await userBox.put("miniChartsTopics", topics.toMap());
  }

  @override
  Future<FetchMiniChartsTopics?> getMiniChartsTopics() async {
    final userBox = await getUserBox;
    final topics = userBox.get("miniChartsTopics") as Map?;
    if(topics == null) return null;
    return FetchMiniChartsTopics.fromMap(topics);
  }

  // Theme

  @override
  Future<void> saveTheme(String theme) async {
    final userBox = await getUserBox;
    await userBox.put("theme", {"value": theme});
  }

  @override
  Future<String?> getTheme() async {
    final userBox = await getUserBox;
    final theme = userBox.get("theme") as Map?;
    return theme?["value"] as String?;
  }

  // Chosen Datetime period

  @override
  Future<void> savePeriod(DateTimeRange period) async {
    final userBox = await getUserBox;
    await userBox.put("period", {
      "start": period.start.toIso8601String(),
      "end": period.end.toIso8601String(),
    });
  }

  @override
  Future<DateTimeRange> getPeriod() async {
    final userBox = await getUserBox;
    final periodMap = userBox.get("period") as Map?;
    if (periodMap != null) {
      final start = DateTime.parse(periodMap["start"] as String);
      final end = DateTime.parse(periodMap["end"] as String);
      return DateTimeRange(start: start, end: end);
    }
    // Default period - last week
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  // Collapsed equip on main page

  @override
  Future<List<String>> getCollapsedEquipment() async {
    final userBox = await getUserBox;
    final collapsed = userBox.get("collapsedEquipment") as List?;
    return collapsed?.cast<String>() ?? [];
  }

  @override
  Future<void> saveCollapsedEquipment(List<String> collapsedKeys) async {
    final userBox = await getUserBox;
    await userBox.put("collapsedEquipment", collapsedKeys);
  }

  // Chosen Equipment

  @override
  Future<String?> getChosenEquipment() async {
    final userBox = await getUserBox;
    final equipment = userBox.get("chosenEquipment") as Map?;
    return equipment?["value"] as String?;
  }

  @override
  Future<void> saveChosenEquipment(String? equipment) async {
    final userBox = await getUserBox;
    await userBox.put("chosenEquipment", {"value": equipment});
  }

  // Multiple Chosen Equipment

  @override
  Future<List<String>?> getMultipleChosenEquipment() async {
    final userBox = await getUserBox;
    final equipment = userBox.get("multipleChosenEquipment") as Map?;
    if (equipment == null) return null;

    final List? equipmentList = equipment["value"] as List?;
    return equipmentList?.map((e) => e.toString()).toList();
  }

  @override
  Future<void> saveMultipleChosenEquipment(List<String>? equipment) async {
    final userBox = await getUserBox;
    await userBox.put("multipleChosenEquipment", {"value": equipment});
  }

  // Chosen Equipment

  @override
  Future<double?> getExcessPercent() async {
    final userBox = await getUserBox;
    final percent = userBox.get("excessPercent") as Map?;
    return percent?["value"] as double?;
  }

  @override
  Future<void> saveExcessPercent(double percent) async {
    final userBox = await getUserBox;
    await userBox.put("excessPercent", {"value": percent});
  }

  // // Equipment config
  //
  // @override
  // Future<ChartConfiguration?> getChartsConfiguration() async {
  //   final userBox = await getUserBox;
  //   final config = userBox.get("chartsConfiguration") as Map?;
  //   if(config == null) return null;
  //   return ChartConfigurationModel.fromMap(config).toEntity();
  // }
  //
  // @override
  // Future<void> saveChartsConfiguration(Map<String, dynamic> config) async {
  //   final userBox = await getUserBox;
  //   await userBox.put("chartsConfiguration", config);
  // }
  //
  // // Charts Layout
  //
  // @override
  // Future<ChartsLayoutData?> getChartsLayout() async {
  //   final userBox = await getUserBox;
  //   final layout = userBox.get("chartsLayout") as Map?;
  //   if(layout == null) return null;
  //   return ChartsLayoutData.fromMap(layout);
  // }
  //
  // @override
  // Future<void> saveChartsLayout(Map<String, dynamic> data) async {
  //   final userBox = await getUserBox;
  //   await userBox.put("chartsLayout", data);
  // }

}