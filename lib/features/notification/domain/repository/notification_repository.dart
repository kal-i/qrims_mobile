import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/notification.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}