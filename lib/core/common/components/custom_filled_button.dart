import 'package:flutter/material.dart';

import '../../../config/themes/app_color.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    this.onTap,
    this.width,
    this.height,
    this.borderRadiusTopLeft,
    this.borderRadiusTopRight,
    this.borderRadiusBottomLeft,
    this.borderRadiusBottomRight,
    required this.text,
    this.color,
    this.prefixWidget,
  });

  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderRadiusTopLeft;
  final double? borderRadiusTopRight;
  final double? borderRadiusBottomLeft;
  final double? borderRadiusBottomRight;
  final String text;
  final Color? color;
  final Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? AppColor.accent;
    final hoverColor = baseColor.withOpacity(0.6);
    final focusColor = baseColor.withOpacity(0.5);
    final splashColor = baseColor.withOpacity(0.7);

    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadiusTopLeft ?? 10.0),
        topRight: Radius.circular(borderRadiusTopRight ?? 10.0),
        bottomLeft: Radius.circular(borderRadiusBottomLeft ?? 10.0),
        bottomRight: Radius.circular(borderRadiusBottomRight ?? 10.0),
      ),
      color: baseColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusTopLeft ?? 10.0),
          topRight: Radius.circular(borderRadiusTopRight ?? 10.0),
          bottomLeft: Radius.circular(borderRadiusBottomLeft ?? 10.0),
          bottomRight: Radius.circular(borderRadiusBottomRight ?? 10.0),
        ),
        hoverColor: hoverColor,
        focusColor: focusColor,
        splashColor: splashColor,
        child: Container(
          width: width ?? 100.0,
          height: height ?? 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadiusTopLeft ?? 10.0),
              topRight: Radius.circular(borderRadiusTopRight ?? 10.0),
              bottomLeft: Radius.circular(borderRadiusBottomLeft ?? 10.0),
              bottomRight: Radius.circular(borderRadiusBottomRight ?? 10.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixWidget != null) prefixWidget!, const SizedBox(width: 10.0,),
              Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColor.lightPrimary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
