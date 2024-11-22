import 'package:network/network.dart';

const _perfMeasurementsKey = "_perfMeasurementsKey";
const _responseParseTimeKey = "response_parsing_latency";

extension ExtraPerfTracking on NetworkResponse {
  Map<String, dynamic> get perfMap {
    if (!extra.containsKey(_perfMeasurementsKey)) {
      extra[_perfMeasurementsKey] = <String, dynamic>{};
    }
    return extra[_perfMeasurementsKey];
  }

  int? get parseTime => perfMap[_responseParseTimeKey];
  set parseTime(int? value) => perfMap[_responseParseTimeKey] = value;
}
