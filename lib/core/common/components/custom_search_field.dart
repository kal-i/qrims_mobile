import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../config/themes/app_color.dart';
import '../../../../config/themes/app_theme.dart';
import '../../../../config/themes/bloc/theme_bloc.dart';
import '../../../config/sizing/sizing_config.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    required this.suggestionsCallback,
    required this.onSelected,
    required this.controller,
    required this.placeholder,
    this.maxLines = 1,
    this.enabled,
    this.prefixIcon,
    this.scrollController,
  });

  final FutureOr<List<String>?> Function(String) suggestionsCallback;
  final void Function(String)? onSelected;
  final TextEditingController controller;
  final String placeholder;
  final int? maxLines;
  final bool? enabled;
  final IconData? prefixIcon;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller,
      constraints: const BoxConstraints(
        maxHeight: 300.0,
      ),
      //hideOnEmpty: true,
      builder: (context, controller, focusNode) {
        return SizedBox(
          height: SizingConfig.heightMultiplier * 12.0,
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            cursorColor: AppColor.accent,
            focusNode: focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.watch<ThemeBloc>().state == AppTheme.light
                  ? AppColor.lightBackground
                  : AppColor.darkBackground,
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColor.error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColor.accent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColor.error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: placeholder,
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.darkPlaceHolderText,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      size: SizingConfig.heightMultiplier * 2.6,
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                vertical: (SizingConfig.heightMultiplier * 12.0) * 0.3, //0.59, // Adjusted padding to match height
                horizontal: 10.0,
              ),
            ),
            maxLines: maxLines,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.watch<ThemeBloc>().state == AppTheme.light
                  ? AppColor.darkPrimary
                  : AppColor.lightPrimary,
              //fontSize: fontSize,
            ),
            validator: ValidationBuilder(requiredMessage: '$placeholder is required')
                .build(),
          ),
        );
      },
      itemBuilder: (context, itemName) {
        return ListTile(
          title: Text(
            itemName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      },
      onSelected: onSelected,
      decorationBuilder: (context, child) {
        return Material(
          type: MaterialType.card,
          elevation: 4,
          borderRadius: BorderRadius.circular(10.0),
          child: child,
        );
      },
      //itemSeparatorBuilder: ,
      errorBuilder: (context, error) {
        String message = 'An error has occurred: $error';
        return Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      },
      emptyBuilder: (context) {
        return Center(
          child: Text(
            'No data found.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      },
      suggestionsCallback: suggestionsCallback,
      scrollController: scrollController,
    );
  }
}
