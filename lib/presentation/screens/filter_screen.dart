import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../widgets/category_selector.dart';
import '../widgets/place_card.dart';
import '../widgets/primary_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String category;
  late String region;
  late String sortBy;

  @override
  void initState() {
    super.initState();
    final controller = context.read<TravelController>();
    category = controller.category;
    region = controller.region;
    sortBy = controller.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelController>();
    final places = controller.visiblePlaces;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: controller.setSearch,
          decoration: const InputDecoration(
            hintText: 'Lake',
            suffixIcon: Icon(Icons.close),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                  setState(() {
                    category = controller.category;
                    region = controller.region;
                    sortBy = controller.sortBy;
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const _Label('Sort By'),
          DropdownButtonFormField<String>(
            initialValue: sortBy,
            items: const ['Recommended', 'Name']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => sortBy = value ?? sortBy),
          ),
          const SizedBox(height: 14),
          const _Label('Show'),
          CategorySelector(
            selected: category,
            onChanged: (item) => setState(() => category = item),
            showRecent: false,
          ),
          const SizedBox(height: 14),
          const _Label('Region'),
          DropdownButtonFormField<String>(
            initialValue: region,
            items:
                const [
                      'All Regions',
                      'Asia',
                      'Europe',
                      'North America',
                      'Oceania',
                    ]
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => region = value ?? region),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Apply Filters',
            icon: Icons.filter_alt,
            onPressed: () => controller.applyFilters(
              nextCategory: category,
              nextRegion: region,
              nextSortBy: sortBy,
            ),
          ),
          const SizedBox(height: 20),
          ...places.map((place) => PlaceCard(place: place, compact: true)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}
