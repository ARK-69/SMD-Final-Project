class Place {
  static const localImageAsset = 'assets/images/travel_placeholder.png';

  const Place({
    required this.id,
    required this.title,
    required this.city,
    required this.country,
    required this.region,
    required this.category,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
  });

  final int id;
  final String title;
  final String city;
  final String country;
  final String region;
  final String category;
  final String imageUrl;
  final String thumbnailUrl;
  final String description;
  final double latitude;
  final double longitude;
  final bool isFavorite;

  Place copyWith({bool? isFavorite}) {
    return Place(
      id: id,
      title: title,
      city: city,
      country: country,
      region: region,
      category: category,
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
      description: description,
      latitude: latitude,
      longitude: longitude,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Place.fromApi(Map<String, dynamic> json) {
    final city = json['city'] as String? ?? '';
    final country = json['country'] as String? ?? '';
    final coordinates = _coordinatesByCity[city] ?? const _Coordinates(0, 0);
    return Place(
      id: json['id'] as int,
      title: json['name'] as String? ?? 'Unknown Place',
      city: city,
      country: country,
      region: _regionByCountry[country] ?? 'Other',
      category: _categoryByCountry[country] ?? 'Culture',
      imageUrl: _optimizedImage(
        json['imageUrl'] as String?,
        width: 960,
        quality: 65,
      ),
      thumbnailUrl: _optimizedImage(
        json['imageUrl'] as String?,
        width: 360,
        quality: 55,
      ),
      description: json['description'] as String? ?? '',
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      title: (json['title'] ?? json['name']) as String,
      city: (json['city'] as String?) ?? '',
      country: json['country'] as String? ?? '',
      region: json['region'] as String,
      category: json['category'] as String,
      imageUrl: _cachedImage(json['imageUrl'] as String?),
      thumbnailUrl: _cachedImage(json['thumbnailUrl'] as String?),
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': title,
      'city': city,
      'country': country,
      'region': region,
      'category': category,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorite': isFavorite,
    };
  }
}

String _cachedImage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return Place.localImageAsset;
  }
  return value;
}

String _optimizedImage(
  String? url, {
  required int width,
  required int quality,
}) {
  if (url == null || url.trim().isEmpty) return Place.localImageAsset;
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return Place.localImageAsset;
  if (!uri.host.contains('images.unsplash.com')) return url;

  return uri
      .replace(
        queryParameters: {
          ...uri.queryParameters,
          'auto': 'format',
          'fit': 'crop',
          'w': '$width',
          'q': '$quality',
        },
      )
      .toString();
}

class _Coordinates {
  const _Coordinates(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

const _regionByCountry = {
  'France': 'Europe',
  'China': 'Asia',
  'USA': 'North America',
  'India': 'Asia',
  'UAE': 'Middle East',
  'Greece': 'Europe',
  'Italy': 'Europe',
  'Peru': 'South America',
  'Australia': 'Oceania',
  'Japan': 'Asia',
  'Canada': 'North America',
  'Jordan': 'Middle East',
  'United Kingdom': 'Europe',
  'Egypt': 'Africa',
  'Turkey': 'Europe',
  'Indonesia': 'Asia',
  'Switzerland': 'Europe',
  'Maldives': 'Asia',
};

const _categoryByCountry = {
  'France': 'Culture',
  'China': 'History',
  'USA': 'City',
  'India': 'Culture',
  'UAE': 'City',
  'Greece': 'Beach',
  'Italy': 'History',
  'Peru': 'Mountain',
  'Australia': 'City',
  'Japan': 'Mountain',
  'Canada': 'Nature',
  'Jordan': 'History',
  'United Kingdom': 'City',
  'Egypt': 'History',
  'Turkey': 'Culture',
  'Indonesia': 'Beach',
  'Switzerland': 'Mountain',
  'Maldives': 'Beach',
};

const _coordinatesByCity = {
  'Paris': _Coordinates(48.8584, 2.2945),
  'Beijing': _Coordinates(40.4319, 116.5704),
  'New York': _Coordinates(40.6892, -74.0445),
  'Agra': _Coordinates(27.1751, 78.0421),
  'Dubai': _Coordinates(25.1972, 55.2744),
  'Santorini': _Coordinates(36.3932, 25.4615),
  'Rome': _Coordinates(41.8902, 12.4922),
  'Cusco': _Coordinates(-13.1631, -72.545),
  'Sydney': _Coordinates(-33.8568, 151.2153),
  'Tokyo': _Coordinates(35.3606, 138.7274),
  'Ontario': _Coordinates(43.0896, -79.0849),
  "Ma'an": _Coordinates(30.3285, 35.4444),
  'London': _Coordinates(51.5007, -0.1246),
  'Giza': _Coordinates(29.9792, 31.1342),
  'Istanbul': _Coordinates(41.0054, 28.9768),
  'Bali': _Coordinates(-8.4095, 115.1889),
  'Zermatt': _Coordinates(46.0207, 7.7491),
  'San Francisco': _Coordinates(37.8199, -122.4783),
  'Nevşehir': _Coordinates(38.6431, 34.827),
  'Malé': _Coordinates(4.1755, 73.5093),
};
