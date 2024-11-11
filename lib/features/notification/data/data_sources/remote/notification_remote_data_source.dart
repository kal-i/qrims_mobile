import '../../models/notification.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}