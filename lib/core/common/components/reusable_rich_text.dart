import 'package:flutter/material.dart';

import '../../../config/sizing/sizing_config.dart';

class ReusableRichText extends StatelessWidget {
  const ReusableRichText({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 2.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          value,
          softWrap: true,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
