import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/category_selector.dart';
import '../widgets/empty_state.dart';
import '../widgets/place_card.dart';
import '../widgets/retry_view.dart';
import '../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      floatingActionButton: const CenterAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const TravelBottomNav(),
      body: SafeArea(
        child: Consumer<TravelController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                _Header(controller: controller),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _Body(controller: controller),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final TravelController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: Scaffold.of(context).openDrawer,
                  icon: const Icon(Icons.menu),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Explore Places',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: controller.setSearch,
            decoration: InputDecoration(
              hintText: 'Search places...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.filters),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CategorySelector(
            selected: controller.category,
            onChanged: (item) => controller.applyFilters(
              nextCategory: item,
              nextRegion: controller.region,
              nextSortBy: controller.sortBy,
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final TravelController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(color: AppColors.purple),
      );
    }
    if (controller.error != null && controller.places.isEmpty) {
      return RetryView(
        key: const ValueKey('retry'),
        onRetry: controller.refresh,
      );
    }

    final places = controller.visiblePlaces;
    if (places.isEmpty) {
      return EmptyState(
        key: const ValueKey('empty'),
        title: 'No places found',
        message:
            "Try adjusting your search or filter to find a trip you'll love.",
        buttonLabel: 'Clear Filters',
        onPressed: controller.clearFilters,
      );
    }

    return RefreshIndicator(
      key: ValueKey('list-${places.length}-${controller.query}'),
      onRefresh: controller.refresh,
      child: AnimatedList(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        initialItemCount: places.length,
        itemBuilder: (context, index, animation) {
          final place = places[index];
          return SizeTransition(
            sizeFactor: animation,
            child: PlaceCard(place: place),
          );
        },
      ),
    );
  }
}
