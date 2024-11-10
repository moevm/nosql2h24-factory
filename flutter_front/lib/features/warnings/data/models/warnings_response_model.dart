import 'package:clean_architecture/features/warnings/data/models/warning_model.dart';

import '../../domain/entities/warnings_data.dart';

class WarningsResponseModel {
  final int page;
  final int pages;
  final int perPage;
  final int total;
  final List<WarningModel> warnings;

  WarningsResponseModel({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.total,
    required this.warnings,
  });

  factory WarningsResponseModel.fromJson(Map<String, dynamic> json) {
    return WarningsResponseModel(
      page: json['page'],
      pages: json['pages'],
      perPage: json['per_page'],
      total: json['total'],
      warnings: (json['warnings'] as List)
          .map((warningJson) => WarningModel.fromJson(warningJson))
          .toList(),
    );
  }

  WarningsData toEntity () => WarningsData(
    page: page,
    pages: pages,
    perPage: perPage,
    total: total,
    warnings: warnings.map((w) => w.toEntity()).toList()
  );
}