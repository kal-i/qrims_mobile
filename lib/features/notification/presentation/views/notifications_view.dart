import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../config/themes/bloc/theme_bloc.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/utils/readable_enum_converter.dart';
import '../../../../core/utils/time_ago_formatter.dart';
import '../../data/models/notification.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late NotificationsBloc _notificationsBloc;

  // final ValueNotifier<List<int>> _items = ValueNotifier(List.generate(10, (index) => index + 1));
  // final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //_scrollController.addListener(_fetchMore);
    _notificationsBloc = context.read<NotificationsBloc>();
    _notificationsBloc.add(GetNotificationsEvent());
  }

  // Future<void> _fetchMore() async {
  //   // check if reach the end of the list
  //   if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
  //     print('triggered!');
  //     _items.value.addAll(List.generate(10, (index) => index + 1));
  //   }
  // }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100.0,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(onPressed: () => _notificationsBloc.add(GetNotificationsEvent()), icon: Icon(Icons.refresh_outlined))
        ],
      ),
      body: BlocListener<NotificationsBloc, NotificationsState>(
        listener: (context, state) {},
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizingConfig.widthMultiplier * 5.0,
              vertical: SizingConfig.heightMultiplier * 3.0,
            ),
            child: Column(
              children: [
                if (state is NotificationsLoading)
                  SpinKitFadingCircle(
                    color: AppColor.accent,
                    size: SizingConfig.heightMultiplier * 2.0,
                  ),
                if (state is NotificationsError)
                  CustomMessageBox.error(
                    message: state.message,
                  ),
                if (state is NotificationsLoaded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return _buildNotificationCard(notification as NotificationModel);
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(HugeIcons.strokeRoundedTask02),
        ),
        title: Text(
          readableEnumConverter(notification.type),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: SizingConfig.heightMultiplier * 2.3,
          ),
        ),
        subtitle: Text(
          notification.message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: SizingConfig.heightMultiplier * 1.8,
          ),
        ),
        trailing: Text(
          timeAgo(notification.createdAt!),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
