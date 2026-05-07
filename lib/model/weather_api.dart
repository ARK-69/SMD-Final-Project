import 'dart:convert';

import 'package:http/http.dart' as http;

import 'place.dart';
import 'weather.dart';

class WeatherApi {
  const WeatherApi(this.client);

  final http.Client client;

  Future<Weather> fetchWeather(Place place) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': place.latitude.toString(),
      'longitude': place.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m',
      'timezone': 'auto',
    });
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to load weather');
    }

    return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
