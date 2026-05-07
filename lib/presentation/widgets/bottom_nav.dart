import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class TravelBottomNav extends StatelessWidget {
  const TravelBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelController>();

    return BottomAppBar(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: Theme.of(context).cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: controller.tabIndex == 0,
              onTap: () {
                controller.setTab(0);
                if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                }
              },
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.map_outlined,
              label: 'Map',
              selected: controller.tabIndex == 1,
              onTap: () => controller.setTab(1),
            ),
          ),
          const SizedBox(width: 36),
          Expanded(
            child: _NavItem(
              icon: Icons.favorite_rounded,
              label: 'Favorites',
              selected: controller.tabIndex == 2,
              onTap: () {
                controller.setTab(2);
                if (ModalRoute.of(context)?.settings.name !=
                    AppRoutes.favorites) {
                  Navigator.pushNamed(context, AppRoutes.favorites);
                }
              },
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: controller.tabIndex == 3,
              onTap: () => controller.setTab(3),
            ),
          ),
        ],
      ),
    );
  }
}

class CenterAddButton extends StatelessWidget {
  const CenterAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: AppColors.purple,
      foregroundColor: Colors.white,
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan a new trip coming soon')),
      ),
      child: const Icon(Icons.add),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.purple : Colors.grey,
              size: 21,
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? AppColors.purple : Colors.grey,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
