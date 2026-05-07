import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'place.dart';

class LocalCache {
  const LocalCache(this.preferences);

  static const _placesKey = 'places_cache';
  static const _favoritesKey = 'favorite_ids';

  final SharedPreferences preferences;

  Future<void> savePlaces(List<Place> places) async {
    final encoded = jsonEncode(places.map((place) => place.toJson()).toList());
    await preferences.setString(_placesKey, encoded);
  }

  List<Place> readPlaces() {
    final encoded = preferences.getString(_placesKey);
    if (encoded == null) return const [];

    final data = jsonDecode(encoded) as List<dynamic>;
    return data
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    await preferences.setStringList(
      _favoritesKey,
      ids.map((id) => id.toString()).toList(),
    );
  }

  Set<int> readFavoriteIds() {
    return preferences.getStringList(_favoritesKey)?.map(int.parse).toSet() ??
        <int>{};
  }
}
