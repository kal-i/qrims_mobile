import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/themes/app_color.dart';

class BaseNavigation extends StatelessWidget {
  const BaseNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: Theme.of(context).dividerColor,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        destinations: destinations
            .map((destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                  selectedIcon: Icon(
                    destination.icon,
                    color: AppColor.accent,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class Destination {
  const Destination({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(
    label: 'Home',
    icon: HugeIcons.strokeRoundedHome01,
  ),
  Destination(
    label: 'Notification',
    icon: HugeIcons.strokeRoundedNotification03,
  ),
  Destination(
    label: 'Scan',
    icon: HugeIcons.strokeRoundedSearchVisual,
  ),
  Destination(
    label: 'History',
    icon: HugeIcons.strokeRoundedFile02,
  ),
  Destination(
    label: 'Profile',
    icon: HugeIcons.strokeRoundedUser,
  )
];
