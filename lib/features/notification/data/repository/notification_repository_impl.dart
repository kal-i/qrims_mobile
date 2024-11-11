import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/notification.dart';
import 'package:fpdart/src/either.dart';

import '../../domain/repository/notification_repository.dart';
import '../data_sources/remote/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({required this.notificationRemoteDataSource,});

  final NotificationRemoteDataSource notificationRemoteDataSource;
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final response = await notificationRemoteDataSource.getNotifications();

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}