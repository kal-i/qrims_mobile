import 'package:flutter/material.dart';

import '../../../../config/sizing/sizing_config.dart';

class BaseAuthView extends StatelessWidget {
  const BaseAuthView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: _BaseAuthViewContent(
        content: child,
      ),
    );
  }
}

class _BaseAuthViewContent extends StatelessWidget {
  const _BaseAuthViewContent({
    super.key,
    required this.content,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizingConfig.widthMultiplier * 4.4,
          vertical: SizingConfig.heightMultiplier * 2.4,
        ),
        child: Column(
          children: [
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
