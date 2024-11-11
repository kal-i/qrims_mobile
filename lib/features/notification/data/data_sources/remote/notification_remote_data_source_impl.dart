import 'dart:convert';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/http_service.dart';
import '../../models/notification.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl({
    required this.httpService,
  });

  final HttpService httpService;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await httpService.get(
        endpoint: notificationsEP,
      );

      if (response.statusCode == 200) {
        print(response.data);
        final notificationsJson =
            (response.data['notifications'] as List<dynamic>)
                .map((notificationJson) =>
                    NotificationModel.fromJson(notificationJson))
                .toList();

        print(notificationsJson);
        return notificationsJson;
      } else {
        throw const ServerException('Failed to load notifications.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
