import 'dart:ui';

enum PercentageType {
  turnOff,
  turnOn,
  work,
  notWork;

  String get presentTranslation {
    switch (this) {
      case PercentageType.turnOff:
        return 'Выключен';
      case PercentageType.turnOn:
        return 'Включен';
      case PercentageType.work:
        return 'Работает';
      case PercentageType.notWork:
        return 'Не работает';
    }
  }

  String get pastTranslation {
    switch (this) {
      case PercentageType.turnOff:
        return 'Был выключен';
      case PercentageType.turnOn:
        return 'Был включен';
      case PercentageType.work:
        return 'Работал';
      case PercentageType.notWork:
        return 'Не работал';
    }
  }

  Color get color {
    switch (this) {
      case PercentageType.turnOff:
        return const Color(0xFF9E9E9E);
      case PercentageType.turnOn:
        return const Color(0xFFFF9800);
      case PercentageType.work:
        return const Color(0xFF4CAF50);
      case PercentageType.notWork:
        return const Color(0xFFE53935);
    }
  }
}

class PercentageEntity {
  final double turnOff;
  final double turnOn;
  final double work;
  final double notWork;

  const PercentageEntity({
    required this.turnOff,
    required this.turnOn,
    required this.work,
    required this.notWork,
  });
}