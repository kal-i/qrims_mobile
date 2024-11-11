import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/get_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({required GetNotifications getNotifications})
      : _getNotifications = getNotifications,
        super(NotificationsInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
  }

  final GetNotifications _getNotifications;

  void _onGetNotifications(
      GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());

    final response = await _getNotifications(NoParams());

    response.fold(
      (l) => emit(NotificationsError(message: l.message)),
      (r) => emit(NotificationsLoaded(notifications: r)),
    );
  }
}
