import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../data/models/notification.dart';
import '../../../../core/models/user/mobile_user.dart';
import '../../../../core/models/user/supply_department_employee.dart';
import '../../../../core/utils/capitalizer.dart';
import '../../../../core/utils/readable_enum_converter.dart';
import '../../../../core/utils/time_ago_formatter.dart';
import '../../../../core/common/components/base_container.dart';
import '../../../../core/common/components/profile_avatar.dart';

typedef NotificationTapCallback = void Function(NotificationModel notification);
typedef MarkAsReadCallback = void Function(NotificationModel notification);

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.onNotificationTap,
    required this.onMarkAsRead,
    required this.notification,
  });

  final NotificationTapCallback onNotificationTap;
  final MarkAsReadCallback onMarkAsRead;
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final user = _mapNotificationSender(notification.sender);

    return GestureDetector(
      onTap: () => onNotificationTap(notification),
      child: BaseContainer(
        child: badges.Badge(
          showBadge: !notification.read,
          child: Row(
            children: [
              ProfileAvatar(
                user: user,
              ),
              SizedBox(
                width: SizingConfig.widthMultiplier * 5.0,
              ),
              Expanded(
                child: _buildNotificationDetails(
                  user,
                  context,
                ),
              ),
              _buildNotificationActions(
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _mapNotificationSender(dynamic sender) {
    return sender is SupplyDepartmentEmployeeModel
        ? SupplyDepartmentEmployeeModel.fromEntity(sender)
        : sender is MobileUserModel
            ? MobileUserModel.fromEntity(sender)
            : null;
  }

  Widget _buildNotificationDetails(dynamic user, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              capitalizeWord(user.name ?? 'Unknown'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: SizingConfig.textMultiplier * 1.8,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(
              width: SizingConfig.widthMultiplier * 2.0,
            ),
            Text(
              _buildUserInfo(user),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColor.accent,
                    fontSize: SizingConfig.textMultiplier * 1.5,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.5,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  String _buildUserInfo(dynamic user) {
    return user is SupplyDepartmentEmployeeModel
        ? readableEnumConverter(user.role)
        : user is MobileUserModel
            ? '${user.officerEntity.officeName} - ${user.officerEntity.positionName}'
            : 'Unknown';
  }

  Widget _buildNotificationActions(BuildContext context) {
    return SizedBox(
      width: SizingConfig.widthMultiplier * 6.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeAgo(notification.createdAt!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 1.5,
                  fontWeight: FontWeight.w400,
                ),
          ),
          PopupMenuButton(
            icon: const Icon(
              HugeIcons.strokeRoundedMoreVertical,
              size: 24.0,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => onMarkAsRead(notification),
                child:
                    Text(notification.read ? 'Mark as unread' : 'Mark as read'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// typedef is used to define a custom type for a function signature, making the code more readable and reusable.
// It allows you to reference a function type without repeating the entire signature, which is particularly useful
// when you have multiple functions that share the same signature. This improves maintainability by making it clear
// what kind of function is expected, and allows you to easily pass around functions as first-class objects.

// Example:
// typedef NotificationTapCallback = void Function(NotificationModel notification);
// This typedef creates a type alias for functions that take a NotificationModel as an argument and return void.
// Instead of writing 'void Function(NotificationModel notification)' repeatedly, we can simply use NotificationTapCallback
// to make the code cleaner and easier to understand.

