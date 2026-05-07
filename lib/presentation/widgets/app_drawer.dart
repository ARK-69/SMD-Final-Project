import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/travel_controller.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelController>();

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.purple, Color(0xFF8B5CFF)],
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  child: Icon(Icons.person, color: AppColors.purple),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abdul Rehman Khan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'k224155@nu.edu.pk',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.map_outlined,
            label: 'Map',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.favorite_border,
            label: 'Favorites',
            onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          _DrawerItem(
            icon: Icons.download_done_outlined,
            label: 'Downloaded',
            onTap: () => Navigator.pushNamed(context, AppRoutes.offline),
          ),
          _DrawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.info_outline,
            label: 'About Us',
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          SwitchListTile(
            value: controller.themeMode == ThemeMode.dark,
            onChanged: (_) => controller.toggleTheme(),
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
      dense: true,
    );
  }
}
