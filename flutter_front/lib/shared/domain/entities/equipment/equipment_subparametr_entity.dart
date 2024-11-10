import '../chart_point.dart';

class SubParameterEntity {
  final String translate;
  final String topic;
  late final List<ChartPoint> miniChartsData;

  SubParameterEntity({
    required this.translate,
    required this.topic,
  });
}