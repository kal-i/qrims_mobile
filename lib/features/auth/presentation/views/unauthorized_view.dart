import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';

class UnauthorizedView extends StatelessWidget {
  const UnauthorizedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          child: _UnAuthorizedViewContent(),
        ),
        TextButton(
          onPressed: () => context.go(RoutingConstants.loginViewRoutePath),
          child: Text(
            'Go back to login',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColor.accent,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _UnAuthorizedViewContent extends StatelessWidget {
  const _UnAuthorizedViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Account Approval Pending',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.0,
        ),
        Icon(
          HugeIcons.strokeRoundedCheckmarkBadge01,
          color: AppColor.lightYellowOutline,
          size: SizingConfig.imageMultiplier * 20.0,
          weight: 5.0,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.0,
        ),
        Text(
          '''
                Thank you for requesting an account. Your account request has been submitted and is currently awaiting approval by an administrator.
              
                You will receive an email notification once your account has been approved.
                ''',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
