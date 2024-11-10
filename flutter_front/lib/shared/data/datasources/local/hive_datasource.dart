import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:clean_architecture/shared/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
}

class HiveLocalDataSourceImpl implements HiveLocalDataSource {
  late Box userBox;

  @override
  Future<void> initializeUserBox(String username) async {
    userBox = await Hive.openBox('user_$username');
  }

  @override
  Future<void> saveUsername(String username) async {
    await userBox.put("username", {"value": username});
  }

  @override
  Future<void> saveToken(String token) async {
    await userBox.put("token", {"value": token});
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await userBox.put("refreshToken", {"value": token});
  }

  @override
  Future<void> saveLogo(String logo) async {
    await userBox.put("logo", <String, dynamic>{"value": logo});
  }

  @override
  Future<String?> getLogo() async {
    final logo = userBox.get("logo") as Map?;
    return logo?["value"] as String?;
  }

  @override
  Future<String?> getUsername() async {
    final username = userBox.get("username");
    return username?["value"] as String?;
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = userBox.get("token") as Map?;
      return token?["value"] as String?;
    } catch (e){
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = userBox.get("refreshToken") as Map?;
    return token?["value"] as String?;
  }


  @override
  Future<void> saveMiniChartsTopics(FetchMiniChartsTopics topics) async {
    await userBox.put("miniChartsTopics", topics.toMap());
  }

  @override
  Future<FetchMiniChartsTopics?> getMiniChartsTopics() async {
    final topics = userBox.get("miniChartsTopics") as Map?;
    if(topics == null) return null;
    return FetchMiniChartsTopics.fromMap(topics);
  }

  // Theme

  @override
  Future<void> saveTheme(String theme) async {
    await userBox.put("theme", {"value": theme});
  }

  @override
  Future<String?> getTheme() async {
    final theme = userBox.get("theme") as Map?;
    return theme?["value"] as String?;
  }

  // Chosen Datetime period

  @override
  Future<void> savePeriod(DateTimeRange period) async {
    await userBox.put("period", {
      "start": period.start.toIso8601String(),
      "end": period.end.toIso8601String(),
    });
  }

  @override
  Future<DateTimeRange> getPeriod() async {
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
    final collapsed = userBox.get("collapsedEquipment") as List?;
    return collapsed?.cast<String>() ?? [];
  }

  @override
  Future<void> saveCollapsedEquipment(List<String> collapsedKeys) async {
    await userBox.put("collapsedEquipment", collapsedKeys);
  }

  // Chosen Equipment

  @override
  Future<String?> getChosenEquipment() async {
    final equipment = userBox.get("chosenEquipment") as Map?;
    return equipment?["value"] as String?;
  }

  @override
  Future<void> saveChosenEquipment(String? equipment) async {
    await userBox.put("chosenEquipment", {"value": equipment});
  }

  // Multiple Chosen Equipment

  @override
  Future<List<String>?> getMultipleChosenEquipment() async {
    final equipment = userBox.get("multipleChosenEquipment") as Map?;
    if (equipment == null) return null;

    final List? equipmentList = equipment["value"] as List?;
    return equipmentList?.map((e) => e.toString()).toList();
  }

  @override
  Future<void> saveMultipleChosenEquipment(List<String>? equipment) async {
    await userBox.put("multipleChosenEquipment", {"value": equipment});
  }

  // Chosen Equipment

  @override
  Future<double?> getExcessPercent() async {
    final percent = userBox.get("excessPercent") as Map?;
    return percent?["value"] as double?;
  }

  @override
  Future<void> saveExcessPercent(double percent) async {
    await userBox.put("excessPercent", {"value": percent});
  }

}