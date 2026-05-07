import 'package:flutter/material.dart';

import '../model/place.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/filter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/offline_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const detail = '/detail';
  static const favorites = '/favorites';
  static const filters = '/filters';
  static const map = '/map';
  static const offline = '/offline';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case detail:
        if (settings.arguments is! Place) {
          return _homeRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DetailScreen(place: settings.arguments! as Place),
        );
      case favorites:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FavoritesScreen(),
        );
      case filters:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FilterScreen(),
        );
      case map:
        if (settings.arguments is! Place) {
          return _homeRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MapScreen(place: settings.arguments! as Place),
        );
      case offline:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OfflineScreen(),
        );
      default:
        return _homeRoute(settings);
    }
  }

  static Route<dynamic> _homeRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const HomeScreen(),
    );
  }
}
