import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            'Profile View',
          ),
          IconButton(
            onPressed: () =>
                context.push(RoutingConstants.nestedSettingsViewRoutePath),
            icon: const Icon(
              HugeIcons.strokeRoundedSettings02,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}
