import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../widgets/place_card.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelController>();
    final cachedPlaces = controller.places;

    return Scaffold(
      floatingActionButton: const CenterAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const TravelBottomNav(),
      appBar: AppBar(title: const Text('Downloaded')),
      body: cachedPlaces.isEmpty
          ? EmptyState(
              title: 'No downloaded places',
              message: 'Load places once online to cache them for offline use.',
              buttonLabel: 'Retry',
              icon: Icons.download_done_outlined,
              onPressed: controller.refresh,
            )
          : RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                children: [
                  Text(
                    'Cached API Places',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Available offline from your last successful API load.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ...cachedPlaces.map(
                    (place) => PlaceCard(place: place, compact: true),
                  ),
                ],
              ),
            ),
    );
  }
}
