import 'dart:convert';

import 'package:http/http.dart' as http;

import 'place.dart';
import 'place_seed_data.dart';

class PlaceApi {
  const PlaceApi(this.client);

  final http.Client client;

  Future<List<Place>> fetchPlaces() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to load places');
    }

    final data = jsonDecode(jsonEncode(placeSeedData)) as List<dynamic>;
    return data
        .map((item) => Place.fromApi(item as Map<String, dynamic>))
        .toList();
  }
}
