import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:simple_moment/simple_moment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputCon = TextEditingController();

  final WeatherController _wCon = WeatherController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: const Color(0xFF303030),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter city',
                        ),
                        controller: _inputCon,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _wCon.getForecast(_inputCon.text.trim());
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _inputCon.text = '';
                      _wCon.clearForecast();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedBuilder(
                    animation: _wCon,
                    builder: (context, Widget? w) {
                      if (_wCon.working) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!_wCon.working) {
                        if (_wCon.error != null) {
                          return Center(
                            child: Text(
                              '${_wCon.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return DefaultTabController(
                            length: _wCon.parsed.entries.length,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      for (MapEntry<DateTime, List<Weather>> w
                                          in _wCon.parsed.entries)
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  _getBackgroundImage(
                                                      w.value.first),
                                                ),
                                                fit: BoxFit.cover),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              buildHeaderEntry(w),
                                              Expanded(
                                                  child: SingleChildScrollView(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  children: [
                                                    for (Weather a
                                                        in w.value.sublist(1))
                                                      buildForecastEntry(a),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                if (_wCon.forecast != null)
                                  TabBar(
                                    indicatorColor: Colors.black87,
                                    indicatorWeight: 4,
                                    tabs: [
                                      for (MapEntry<DateTime, List<Weather>> e
                                          in _wCon.parsed.entries)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildIcon(e.value.first),
                                            Text(
                                              Moment.fromDate(e.key)
                                                  .format('d'),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                    ],
                                  )
                              ],
                            ),
                          );
                        }
                      }
                      return Container();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForecastEntry(Weather a) {
    return Card(
      color: Colors.white.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            buildIcon(a),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${a.weatherMain}, ${a.weatherDescription}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    Moment.fromDate(a.date as DateTime).format('hh:mm a'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    a.temperature.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderEntry(MapEntry<DateTime, List<Weather>> w) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withOpacity(0.5),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildIcon3x(w.value.first),
          Text(
            Moment.fromDate(w.key).format('MMMM d'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            Moment.fromDate(w.value.first.date as DateTime).format('hh:mm a'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            w.value.first.areaName as String,
            style: const TextStyle(fontSize: 24),
          ),
          Text(w.value.first.temperature.toString()),
          Text(
              '${w.value.first.weatherMain}, ${w.value.first.weatherDescription}'),
        ],
      ),
    );
  }

  String _getBackgroundImage(Weather weather) {
    int weatherCode = weather.weatherConditionCode as int;
    if (weatherCode >= 200 && weatherCode < 300) {
      return 'https://www.rescueairtx.com/images/blog/png-base64dd1fe11ef962dc81.png';
    } else if (weatherCode >= 300 && weatherCode < 500) {
      return 'https://www.thoughtco.com/thmb/e-lNG0rEXRiAfHNtR6RLOL98XPo=/2576x2576/smart/filters:no_upscale()/drops-of-rain-on-glass-838815210-5a823cc0a18d9e0036e325e2.jpg';
    } else if (weatherCode >= 500 && weatherCode < 600) {
      return 'https://s7d2.scene7.com/is/image/TWCNews/heavy_rain_jpg';
    } else if (weatherCode >= 500 && weatherCode < 600) {
      return 'https://blog.mystart.com/wp-content/uploads/shutterstock_238248124-e1520010671722.jpg';
    } else if (weatherCode >= 600 && weatherCode < 800) {
      return 'https://images.unsplash.com/photo-1603794052293-650dbdeef72c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1112&q=80';
    } else if (weatherCode == 800) {
      return 'https://wallpapercave.com/wp/wp5864636.jpg';
    } else {
      return 'https://images.pexels.com/photos/53594/blue-clouds-day-fluffy-53594.jpeg';
    }
  }

  Image buildIcon(Weather a) {
    return Image.network(
        'https://openweathermap.org/img/wn/${a.weatherIcon}@2x.png');
  }

  Image buildIcon3x(Weather a) {
    return Image.network(
        'https://openweathermap.org/img/wn/${a.weatherIcon}@2x.png');
  }
}
