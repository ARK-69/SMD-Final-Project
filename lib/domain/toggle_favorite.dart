import 'place_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this.repository);

  final PlaceRepository repository;

  Future<Set<int>> call(Set<int> currentIds, int placeId) async {
    final nextIds = {...currentIds};
    if (!nextIds.add(placeId)) {
      nextIds.remove(placeId);
    }
    await repository.saveFavoriteIds(nextIds);
    return nextIds;
  }
}
