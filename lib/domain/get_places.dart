import '../model/place.dart';
import 'place_repository.dart';

class GetPlaces {
  const GetPlaces(this.repository);

  final PlaceRepository repository;

  Future<List<Place>> call({bool refresh = false}) {
    return repository.getPlaces(refresh: refresh);
  }
}
