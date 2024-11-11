part of 'notifications_bloc.dart';

sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.notifications,
  });

  final List<NotificationEntity> notifications;
}

final class NotificationsError extends NotificationsState {
  const NotificationsError({
    required this.message,
  });

  final String message;
}
