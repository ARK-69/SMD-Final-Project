import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/place.dart';
import '../controllers/travel_controller.dart';
import '../routes.dart';
import 'favorite_button.dart';
import 'place_image.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({required this.place, super.key, this.compact = false});

  final Place place;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: compact ? 12 : 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          context.read<TravelController>().registerRecentPlace(place.id);
          Navigator.pushNamed(context, AppRoutes.detail, arguments: place);
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: compact
              ? _CompactCard(place: place)
              : _LargeCard(place: place),
        ),
      ),
    );
  }
}

class _LargeCard extends StatelessWidget {
  const _LargeCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'place-${place.id}',
          child: PlaceImage(
            imageUrl: place.imageUrl,
            height: 150,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 12),
          child: Row(
            children: [
              Expanded(child: _PlaceText(place: place)),
              FavoriteButton(place: place),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          PlaceImage(
            imageUrl: place.thumbnailUrl,
            height: 70,
            width: 82,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 12),
          Expanded(child: _PlaceText(place: place)),
          FavoriteButton(place: place, compact: true),
        ],
      ),
    );
  }
}

class _PlaceText extends StatelessWidget {
  const _PlaceText({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          place.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 3),
        Text(
          '${place.city}, ${place.country}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
