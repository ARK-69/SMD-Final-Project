import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/filter_places.dart';
import '../../domain/get_places.dart';
import '../../domain/get_weather.dart';
import '../../domain/toggle_favorite.dart';
import '../../model/place.dart';
import '../../model/weather.dart';

class TravelController extends ChangeNotifier {
  TravelController({
    required this.getPlaces,
    required this.getWeather,
    required this.toggleFavoriteUseCase,
    required this.filterPlaces,
  });

  final GetPlaces getPlaces;
  final GetWeather getWeather;
  final ToggleFavorite toggleFavoriteUseCase;
  final FilterPlaces filterPlaces;

  final _weatherCache = <int, Weather>{};
  Timer? _debounce;
  List<Place> _places = [];
  Set<int> _favoriteIds = {};
  final List<int> _recentPlaceIds = [];
  DateTime? _lastLoadedAt;

  bool isLoading = true;
  bool isOffline = false;
  String? error;
  String query = '';
  String category = 'All';
  String region = 'All Regions';
  String sortBy = 'Recommended';
  int tabIndex = 0;
  ThemeMode themeMode = ThemeMode.light;

  List<Place> get places => _places;

  List<Place> get visiblePlaces {
    final filtered = filterPlaces(
      _places,
      query: query,
      category: category == 'Recent' ? 'All' : category,
      region: region,
      sortBy: sortBy,
    );

    if (category != 'Recent') return filtered;

    final recentSet = _recentPlaceIds.toSet();
    final recentPlaces = filtered
        .where((place) => recentSet.contains(place.id))
        .toList();

    recentPlaces.sort((a, b) {
      return _recentPlaceIds
          .indexOf(b.id)
          .compareTo(_recentPlaceIds.indexOf(a.id));
    });

    return recentPlaces;
  }

  List<Place> get favorites {
    return _places.where((place) => place.isFavorite).toList();
  }

  Future<void> loadPlaces({bool refresh = false}) async {
    final hasFreshMemoryData =
        !refresh &&
        _places.isNotEmpty &&
        _lastLoadedAt != null &&
        DateTime.now().difference(_lastLoadedAt!) < const Duration(minutes: 10);
    if (hasFreshMemoryData) return;

    isLoading = _places.isEmpty || refresh;
    error = null;
    if (isLoading) notifyListeners();

    try {
      _places = await getPlaces(refresh: refresh);
      _favoriteIds = _places
          .where((place) => place.isFavorite)
          .map((place) => place.id)
          .toSet();
      _lastLoadedAt = DateTime.now();
      isOffline = false;
    } catch (_) {
      error = 'We could not load places right now.';
      isOffline = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadPlaces(refresh: true);

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      query = value;
      notifyListeners();
    });
  }

  void applyFilters({
    required String nextCategory,
    required String nextRegion,
    required String nextSortBy,
  }) {
    category = nextCategory;
    region = nextRegion;
    sortBy = nextSortBy;
    notifyListeners();
  }

  void clearFilters() {
    query = '';
    category = 'All';
    region = 'All Regions';
    sortBy = 'Recommended';
    notifyListeners();
  }

  Future<void> toggleFavorite(int placeId) async {
    _favoriteIds = await toggleFavoriteUseCase(_favoriteIds, placeId);
    _places = _places
        .map(
          (place) =>
              place.copyWith(isFavorite: _favoriteIds.contains(place.id)),
        )
        .toList();
    notifyListeners();
  }

  void registerRecentPlace(int placeId) {
    _recentPlaceIds.remove(placeId);
    _recentPlaceIds.add(placeId);
    if (_recentPlaceIds.length > 20) {
      _recentPlaceIds.removeAt(0);
    }
    notifyListeners();
  }

  Future<Weather> weatherFor(Place place) async {
    final cachedWeather = _weatherCache[place.id];
    if (cachedWeather != null) return cachedWeather;

    final weather = await getWeather(place);
    _weatherCache[place.id] = weather;
    return weather;
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
