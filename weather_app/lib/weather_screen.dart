import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_item.dart';
import 'package:weather_app/hourly_weather_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String apiKey = 'abe6e25122ef64a647f1a49746ce9cc7';
      String countryCode = 'uk';
      String cityName = 'London';

      final res = await http.get(
        Uri.parse(
            "http://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryCode&appid=$apiKey"),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message']; // or specific your own error.
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh)),
          // GestureDetector( // for splash effect use InkWell
          // onTap: () {},
          // child: const Icon(Icons.refresh),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final curretTemp = data['list'][0]['main']['temp'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$curretTemp°F",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Icon(Icons.cloud, size: 64),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    "RAIN",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //  weather forcast cards
                    const Text(
                      "Weather Forecast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // const SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       HourlyWeatherItem(
                    //         time: "00:00",
                    //         temperature: "312",
                    //         icon: Icons.cloud,
                    //       ),
                    //       HourlyWeatherItem(
                    //         time: "00:00",
                    //         temperature: "312",
                    //         icon: Icons.cloud,
                    //       ),
                    //       HourlyWeatherItem(
                    //         time: "00:00",
                    //         temperature: "312",
                    //         icon: Icons.cloud,
                    //       ),
                    //       HourlyWeatherItem(
                    //         time: "00:00",
                    //         temperature: "312",
                    //         icon: Icons.cloud,
                    //       ),
                    //       HourlyWeatherItem(
                    //         time: "00:00",
                    //         temperature: "312",
                    //         icon: Icons.cloud,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final forcastDesc =
                                data['list'][index + 1]['weather'][0]['main'];
                            final forcastTime =
                                data['list'][index + 1]['dt_txt'];
                            final time = DateTime.parse(forcastTime);
                            return HourlyWeatherItem(
                                time: DateFormat.j().format(time),
                                temperature: forcastDesc,
                                icon: forcastDesc == 'Clouds' ||
                                        forcastDesc == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny);
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //  additional info card
                    const Text(
                      "Additional Information",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalWidgetItem(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: "91",
                        ),
                        AdditionalWidgetItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: "7.5",
                        ),
                        AdditionalWidgetItem(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: "1000",
                        ),
                      ],
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
