import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import 'category_selector.dart';
import 'primary_button.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
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
    final controller = context.read<TravelController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Label('Sort By'),
          _Dropdown(
            value: sortBy,
            values: const ['Recommended', 'Name'],
            onChanged: (value) => setState(() => sortBy = value),
          ),
          const SizedBox(height: 14),
          _Label('Show'),
          CategorySelector(
            selected: category,
            onChanged: (value) => setState(() => category = value),
            showRecent: false,
          ),
          const SizedBox(height: 14),
          _Label('Region'),
          _Dropdown(
            value: region,
            values: const [
              'All Regions',
              'Asia',
              'Europe',
              'North America',
              'Oceania',
            ],
            onChanged: (value) => setState(() => region = value),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Apply Filters',
            icon: Icons.filter_alt,
            onPressed: () {
              controller.applyFilters(
                nextCategory: category,
                nextRegion: region,
                nextSortBy: sortBy,
              );
              Navigator.pop(context);
            },
          ),
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

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
