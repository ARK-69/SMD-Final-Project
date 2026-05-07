import '../model/place.dart';
import '../model/weather.dart';

abstract class PlaceRepository {
  Future<List<Place>> getPlaces({bool refresh = false});

  Future<Weather> getWeather(Place place);

  Future<Set<int>> getFavoriteIds();

  Future<void> saveFavoriteIds(Set<int> ids);
}
