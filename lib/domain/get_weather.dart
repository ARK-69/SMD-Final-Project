import '../model/place.dart';
import '../model/weather.dart';
import 'place_repository.dart';

class GetWeather {
  const GetWeather(this.repository);

  final PlaceRepository repository;

  Future<Weather> call(Place place) {
    return repository.getWeather(place);
  }
}
