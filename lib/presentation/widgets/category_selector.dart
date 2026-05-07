import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.selected,
    required this.onChanged,
    super.key,
    this.showRecent = true,
  });

  final String selected;
  final ValueChanged<String> onChanged;
  final bool showRecent;

  static const values = ['All', 'Favorites', 'Recent'];

  @override
  Widget build(BuildContext context) {
    final visibleValues = showRecent
        ? values
        : values.where((value) => value != 'Recent').toList();

    return Row(
      children: visibleValues
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: item == visibleValues.last ? 0 : 8,
                ),
                child: ChoiceChip(
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(item, textAlign: TextAlign.center),
                  ),
                  selected: selected == item,
                  onSelected: (_) => onChanged(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
