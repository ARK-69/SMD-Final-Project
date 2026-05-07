import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/place.dart';
import '../../model/weather.dart';
import '../controllers/travel_controller.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/favorite_button.dart';
import '../widgets/place_image.dart';
import '../widgets/primary_button.dart';
import '../widgets/weather_card.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.place, super.key});

  final Place place;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final place = context.select<TravelController, Place>(
      (controller) => controller.places.firstWhere(
        (item) => item.id == widget.place.id,
        orElse: () => widget.place,
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: FavoriteButton(place: place),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'place-${place.id}',
                child: PlaceImage(
                  imageUrl: place.imageUrl,
                  height: 330,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  place.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.purple,
                      size: 18,
                    ),
                    Text('${place.city}, ${place.country}'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(place.description),
                const SizedBox(height: 22),
                FutureBuilder<Weather>(
                  future: context.read<TravelController>().weatherFor(place),
                  builder: (context, snapshot) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: snapshot.hasData
                          ? WeatherCard(
                              key: const ValueKey('weather'),
                              weather: snapshot.data!,
                            )
                          : const Card(
                              key: ValueKey('weather-loading'),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _AboutPlace(
                  place: place,
                  expanded: expanded,
                  onToggle: () => setState(() => expanded = !expanded),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'View on Map',
                  icon: Icons.map_outlined,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.map,
                    arguments: place,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPlace extends StatelessWidget {
  const _AboutPlace({
    required this.place,
    required this.expanded,
    required this.onToggle,
  });

  final Place place;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  Text(
                    'About the place',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  expanded
                      ? '${place.description} Visit during golden hour for the best views, and keep this destination saved for offline access while travelling.'
                      : place.description,
                  maxLines: expanded ? null : 3,
                  overflow: expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
