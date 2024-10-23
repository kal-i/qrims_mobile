import 'package:flutter/material.dart';

import '../../../../config/sizing/sizing_config.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizingConfig.widthMultiplier * 5.0,
            vertical: SizingConfig.heightMultiplier * 3.0,
          ),
          child: Column(
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
