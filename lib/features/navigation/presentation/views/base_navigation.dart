import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/themes/app_color.dart';

class BaseNavigation extends StatefulWidget {
  const BaseNavigation({
    super.key,
    //required this.navigationShell,
    required this.child,
  });

  //final StatefulNavigationShell navigationShell;
  final Widget child;

  @override
  State<BaseNavigation> createState() => _BaseNavigationState();
}

class _BaseNavigationState extends State<BaseNavigation> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  final List<String> _navigationRoutes = [
    RoutingConstants.homeViewRoutePath,
    RoutingConstants.notificationViewRoutePath,
    RoutingConstants.qrScannerViewRoutePath,
    RoutingConstants.historyViewRoutePath,
    RoutingConstants.profileViewRoutePath,
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: widget.child, // navigationShell,
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, currentIndex, child) {
          return NavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: currentIndex, // navigationShell.currentIndex,
            onDestinationSelected: (selectedIndex) {
              _currentIndex.value = selectedIndex;
              context.go(_navigationRoutes[selectedIndex]);
            }, // navigationShell.goBranch,
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
          );
        }
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
