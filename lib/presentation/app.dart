import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/travel_controller.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class TravelApp extends StatefulWidget {
  const TravelApp({super.key});

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(context.read<TravelController>().loadPlaces);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<TravelController, ThemeMode>(
      (controller) => controller.themeMode,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Travel Companion',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
