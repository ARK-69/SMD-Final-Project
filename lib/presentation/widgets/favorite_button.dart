import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/place.dart';
import '../controllers/travel_controller.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.place, super.key, this.compact = false});

  final Place place;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () async {
        final isAdding = !place.isFavorite;
        await context.read<TravelController>().toggleFavorite(place.id);
        if (isAdding) {
          await NotificationService.instance.showFavoriteAdded(place);
        }
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: Icon(
          place.isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(place.isFavorite),
          color: place.isFavorite ? AppColors.pink : null,
          size: compact ? 20 : 24,
        ),
      ),
    );
  }
}
