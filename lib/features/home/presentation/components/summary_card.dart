import 'package:flutter/material.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.background,
    required this.outlineColor,
    required this.foreground,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color background;
  final Color outlineColor;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .4,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: outlineColor,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: background,
            ),
            child: Icon(
              icon,
              color: outlineColor,
              size: 20.0,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontSize: SizingConfig.textMultiplier * 1.6,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontSize: SizingConfig.textMultiplier * 3.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
