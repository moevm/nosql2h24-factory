import '../../domain/entities/percentage_entity.dart';

class PercentageModel {
  final double turnOff;
  final double turnOn;
  final double work;

  const PercentageModel({
    required this.turnOff,
    required this.turnOn,
    required this.work,
  });

  factory PercentageModel.fromJson(Map<String, dynamic> json) {
    return PercentageModel(
      turnOff: (json['turn_off'] as num).toDouble(),
      turnOn: (json['turn_on'] as num).toDouble(),
      work: (json['work'] as num).toDouble(),
    );
  }

  PercentageEntity toEntity() {
    return PercentageEntity(
      turnOff: turnOff,
      turnOn: turnOn,
      work: work,
      notWork: 100 - (turnOff + turnOn + work),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turn_off': turnOff,
      'turn_on': turnOn,
      'work': work,
    };
  }
}