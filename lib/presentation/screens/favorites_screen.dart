import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelController>();
    final favorites = controller.favorites;

    return Scaffold(
      floatingActionButton: const CenterAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const TravelBottomNav(),
      appBar: AppBar(
        title: const Text('My Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: favorites.isEmpty
          ? EmptyState(
              title: 'No favorites yet',
              message: 'Tap the heart on a place to keep it here.',
              buttonLabel: 'Explore',
              icon: Icons.favorite_border,
              onPressed: Navigator.of(context).pop,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              itemBuilder: (context, index) =>
                  PlaceCard(place: favorites[index], compact: true),
            ),
    );
  }
}
