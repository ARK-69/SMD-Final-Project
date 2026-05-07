import '../domain/place_repository.dart';
import 'local_cache.dart';
import 'place.dart';
import 'place_api.dart';
import 'weather.dart';
import 'weather_api.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  const PlaceRepositoryImpl({
    required this.placeApi,
    required this.weatherApi,
    required this.cache,
  });

  final PlaceApi placeApi;
  final WeatherApi weatherApi;
  final LocalCache cache;

  @override
  Future<List<Place>> getPlaces({bool refresh = false}) async {
    final favorites = cache.readFavoriteIds();
    if (!refresh) {
      final cached = cache.readPlaces();
      if (cached.isNotEmpty) {
        return _withFavorites(cached, favorites);
      }
    }

    try {
      final places = await placeApi.fetchPlaces();
      final markedPlaces = _withFavorites(places, favorites);
      await cache.savePlaces(markedPlaces);
      return markedPlaces;
    } catch (_) {
      final cached = cache.readPlaces();
      if (cached.isNotEmpty) {
        return _withFavorites(cached, favorites);
      }
      rethrow;
    }
  }

  @override
  Future<Weather> getWeather(Place place) {
    return weatherApi.fetchWeather(place);
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    return cache.readFavoriteIds();
  }

  @override
  Future<void> saveFavoriteIds(Set<int> ids) {
    return cache.saveFavoriteIds(ids);
  }

  List<Place> _withFavorites(List<Place> places, Set<int> favorites) {
    return places
        .map(
          (place) => place.copyWith(isFavorite: favorites.contains(place.id)),
        )
        .toList();
  }
}
