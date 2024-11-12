import '../../../../core/types/influx_formater.dart';
import '../../domain/entities/description.dart';

class DescriptionModel {
  final String text;
  final DateTime updated;
  final String author;

  DescriptionModel({
    required this.text,
    required this.updated,
    required this.author,
  });

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      text: json['text'],
      updated: DateTime.parse(json['updated']),
      author: json['author'],
    );
  }

  Map<String, String> toJson() {
    return {
      'text': text,
      'updated': formatDateTimeForInflux(updated, format: "Z"),
      'author': author,
    };
  }

  factory DescriptionModel.fromEntity(Description entity) {
    return DescriptionModel(
      text: entity.text,
      updated: entity.updated,
      author: entity.author,
    );
  }

  Description toEntity() => Description(
    text: text,
    updated: updated,
    author: author,
  );
}
