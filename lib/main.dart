import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/filter_places.dart';
import 'domain/get_places.dart';
import 'domain/get_weather.dart';
import 'domain/toggle_favorite.dart';
import 'model/local_cache.dart';
import 'model/place_api.dart';
import 'model/place_repository_impl.dart';
import 'model/weather_api.dart';
import 'presentation/app.dart';
import 'presentation/controllers/travel_controller.dart';
import 'presentation/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  final preferences = await SharedPreferences.getInstance();
  final client = http.Client();
  final repository = PlaceRepositoryImpl(
    placeApi: PlaceApi(client),
    weatherApi: WeatherApi(client),
    cache: LocalCache(preferences),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => TravelController(
        getPlaces: GetPlaces(repository),
        getWeather: GetWeather(repository),
        toggleFavoriteUseCase: ToggleFavorite(repository),
        filterPlaces: const FilterPlaces(),
      ),
      child: const TravelApp(),
    ),
  );
}
