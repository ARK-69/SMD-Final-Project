import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../model/place.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({required this.place, super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(place.latitude, place.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: point, initialZoom: 10),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.project',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 56,
                    height: 56,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.pink,
                      size: 46,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _MapPlaceCard(place: place),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceCard extends StatelessWidget {
  const _MapPlaceCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.map, color: AppColors.purple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text('${place.country} • ${place.region}'),
                  Text(
                    '${place.latitude.toStringAsFixed(3)}, ${place.longitude.toStringAsFixed(3)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
