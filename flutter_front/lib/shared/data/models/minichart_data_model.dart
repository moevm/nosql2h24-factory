class ChartDataPoint {
  final DateTime time;
  final double value;

  ChartDataPoint(this.time, this.value);

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      DateTime.parse(json['time'].toString()),
      json['value'] is num ? (json['value'] as num).toDouble() : 0.0,
    );
  }
}

class MiniChartDataModel {
  final Map<String, Map<String, Map<String, List<ChartDataPoint>?>>> data;

  MiniChartDataModel(this.data);

  factory MiniChartDataModel.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, Map<String, List<ChartDataPoint>?>>> result = {};

    json.forEach((key, value) { // equip
      if (value is Map) {
        result[key] = {};
        value.forEach((paramKey, paramValue) { // param
          if (paramValue is Map) {
            result[key]![paramKey] = {};
            paramValue.forEach((subParamKey, subParamValue) { // subparam
              if (subParamValue is List) {
                result[key]![paramKey]![subParamKey] = subParamValue
                    .map((e) => e is Map<String, dynamic>
                    ? ChartDataPoint.fromJson(e)
                    : ChartDataPoint(DateTime.now(), 0.0))
                    .toList();
              } else {
                result[key]![paramKey]![subParamKey] = null;
              }
            });
          }
        });
      }
    });

    return MiniChartDataModel(result);
  }
}

extension MiniChartDataModelExtension on MiniChartDataModel {
  MiniChartDataModel updateWithNewData(MiniChartDataModel newData) {
    final updatedData = Map<String, Map<String, Map<String, List<ChartDataPoint>?>>>.from(data);

    newData.data.forEach((equipKey, equipValue) {
      equipValue.forEach((paramKey, paramValue) {
        paramValue.forEach((subParamKey, newDataPoints) {
          if (newDataPoints != null) {
            if (updatedData[equipKey]?[paramKey]?[subParamKey] == null) {
              // Если в старых данных нет этого ключа, создаем новый список
              updatedData[equipKey] ??= {};
              updatedData[equipKey]![paramKey] ??= {};
              updatedData[equipKey]![paramKey]![subParamKey] = List<ChartDataPoint>.from(newDataPoints);
            } else {
              // Если старые данные существуют, обновляем их
              final oldDataPoints = updatedData[equipKey]![paramKey]![subParamKey]!;
              final updatedDataPoints = List<ChartDataPoint>.from(oldDataPoints);

              // Удаляем столько же точек с начала, сколько новых точек добавляем
              updatedDataPoints.removeRange(0, newDataPoints.length);
              // Добавляем новые точки в конец
              updatedDataPoints.addAll(newDataPoints);

              updatedData[equipKey]![paramKey]![subParamKey] = updatedDataPoints;
            }
          }
        });
      });
    });

    return MiniChartDataModel(updatedData);
  }

  Map<String, Map<String, Map<String, List<double>?>>> get valuesOnly {
    final result = <String, Map<String, Map<String, List<double>?>>>{};

    data.forEach((equipKey, equipValue) {
      result[equipKey] = {};
      equipValue.forEach((paramKey, paramValue) {
        result[equipKey]![paramKey] = {};
        paramValue.forEach((subParamKey, dataPoints) {
          result[equipKey]![paramKey]![subParamKey] =
              dataPoints?.map((point) => point.value).toList();
        });
      });
    });

    return result;
  }

  // Вспомогательный метод для получения значений для графика
  List<double> getValuesForChart(String equipKey, String paramKey, String subParamKey) {
    return data[equipKey]?[paramKey]?[subParamKey]?.map((point) => point.value).toList() ?? [];
  }

  // Вспомогательный метод для получения временных меток для графика
  List<DateTime> getTimestampsForChart(String equipKey, String paramKey, String subParamKey) {
    return data[equipKey]?[paramKey]?[subParamKey]?.map((point) => point.time).toList() ?? [];
  }
}