import '../model/place.dart';

class FilterPlaces {
  const FilterPlaces();

  List<Place> call(
    List<Place> places, {
    required String query,
    required String category,
    required String region,
    required String sortBy,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    var result = places.where((place) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          place.title.toLowerCase().contains(normalizedQuery) ||
          place.city.toLowerCase().contains(normalizedQuery) ||
          place.country.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          category == 'All' ||
          category == 'Recent' ||
          (category == 'Favorites' && place.isFavorite);
      final matchesRegion = region == 'All Regions' || place.region == region;
      return matchesQuery && matchesCategory && matchesRegion;
    }).toList();

    if (sortBy == 'Name') {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy == 'Recommended') {
      result.sort((a, b) => a.id.compareTo(b.id));
    }

    return result;
  }
}
