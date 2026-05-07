import 'package:flutter/material.dart';

import '../../model/weather.dart';
import '../theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({required this.weather, super.key});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Current Weather',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                const Icon(Icons.wb_sunny, color: AppColors.yellow, size: 34),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${weather.temperature.round()}°C',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _WeatherStat(
                  label: 'Wind',
                  value: '${weather.windSpeed.round()} km/h',
                ),
                _WeatherStat(label: 'Humidity', value: '${weather.humidity}%'),
                _WeatherStat(
                  label: 'Feels Like',
                  value: '${weather.feelsLike.round()}°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  const _WeatherStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
