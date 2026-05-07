class Weather {
  const Weather({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
  });

  final double temperature;
  final double windSpeed;
  final int humidity;
  final double feelsLike;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
    );
  }
}
