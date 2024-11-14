import 'purchase_request.dart';

import '../../../features/notification/domain/entities/notification.dart';

class PurchaseRequestWithNotificationTrailEntity {
  const PurchaseRequestWithNotificationTrailEntity({
    required this.purchaseRequestEntity,
    required this.notificationEntities,
  });

  final PurchaseRequestEntity purchaseRequestEntity;
  final List<NotificationEntity> notificationEntities;
}
