import '../../../../core/error/failure.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification.dart';
import '../repository/notification_repository.dart';

class GetNotifications implements UseCase<List<NotificationEntity>, NoParams> {
  const GetNotifications({required this.notificationRepository,});

  final NotificationRepository notificationRepository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) async {
    return await notificationRepository.getNotifications();
  }
}