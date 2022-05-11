import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherController with ChangeNotifier {
  WeatherFactory wf = WeatherFactory('81e69805e6a0c46b1cae3b958a78f0cb');
  List<Weather>? forecast;
  bool working = false;
  String? error;

  Map<DateTime, List<Weather>> get parsed {
    Map<DateTime, List<Weather>> result = {};
    if (forecast == null) {
      return result;
    } else {
      for (Weather w in forecast as List<Weather>) {
        DateTime key = DateTime(
            w.date?.year as int, w.date?.month as int, w.date?.day as int);
        if (!result.containsKey(key)) result[key] = [];
        result[key]?.add(w);
      }
      for (DateTime key in result.keys) {
        result[key]?.sort((Weather a, Weather b) {
          return a.date?.compareTo(b.date as DateTime) as int;
        });
      }
      return result;
    }
  }

  clearForecast() {
    forecast = null;
    error = null;
    notifyListeners();
  }

  getForecast(String cityName) async {
    try {
      working = true;
      notifyListeners();
      forecast = await wf.fiveDayForecastByCityName(cityName);
    } on OpenWeatherAPIException catch (e) {
      error = e.toString();
      print(e);
    }
    working = false;
    notifyListeners();
  }
}
