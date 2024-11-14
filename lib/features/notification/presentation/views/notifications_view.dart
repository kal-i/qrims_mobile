import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../config/themes/bloc/theme_bloc.dart';
import '../../../../core/common/components/base_container.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/pagination_controls.dart';
import '../../../../core/constants/assets_path.dart';
import '../../../../core/entities/user/supply_department_employee.dart';
import '../../../../core/models/user/mobile_user.dart';
import '../../../../core/models/user/supply_department_employee.dart';
import '../../../../core/utils/capitalizer.dart';
import '../../../../core/utils/date_formatter.dart';
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

  int _currentPage = 1;
  int _pageSize = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _notificationsBloc = context.read<NotificationsBloc>();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _notificationsBloc.add(
      GetNotificationsEvent(
        page: _currentPage,
        pageSize: _pageSize,
      ),
    );
  }

  void _refreshNotificationList() {
    _currentPage = 1;
    _fetchNotifications();
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsLoaded) {
              _totalRecords = state.totalNotificationsCount;
            }
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizingConfig.widthMultiplier * 5.0,
                vertical: SizingConfig.heightMultiplier * 3.0,
              ),
              child: Column(
                children: [
                  _buildNotificationHeader(),
                  SizedBox(
                    height: SizingConfig.heightMultiplier * 2.5,
                  ),
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
                      child: RefreshIndicator(
                        onRefresh: () async => _refreshNotificationList(),
                        child: ListView.builder(
                          itemCount: state.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = state.notifications[index];
                            return _buildNotificationCard(
                                notification as NotificationModel);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNotificationHeader() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            PaginationControls(
              currentPage: _currentPage,
              totalRecords: _totalRecords,
              pageSize: _pageSize,
              onPageChanged: (page) {
                _currentPage = page;
                _fetchNotifications();
              },
              onPageSizeChanged: (size) {
                _pageSize = size;
                _fetchNotifications();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    // I need your suggestion here because the supply dept employee model contains role which I may need to display along with the name
    // if user is mobile user, I need to display the office name and position
    final user = notification.sender is SupplyDepartmentEmployeeModel
        ? SupplyDepartmentEmployeeModel.fromEntity(
            notification.sender as SupplyDepartmentEmployeeEntity)
        : MobileUserModel.fromEntity(notification.sender as MobileUserModel);

    String? userInfo = '';
    if (user is SupplyDepartmentEmployeeModel) {
      userInfo = readableEnumConverter(user.role);
    }

    if (user is MobileUserModel) {
      userInfo =
          '${user.officerEntity.officeName} - ${user.officerEntity.positionName}';
    }

    final ValueNotifier<bool> read = ValueNotifier(notification.read);

    return GestureDetector(
      onTap: () {
        _notificationsBloc.add(ReadNotificationEvent(notificationId: notification.id, read: true,),);
      },
      child: ValueListenableBuilder(
        valueListenable: read,
        builder: (context, read, child) {
          return BaseContainer(
            child: badges.Badge(
              showBadge: read, // !notification.read,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// init part
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              ImagePath.profile,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: SizingConfig.widthMultiplier * 5.0,
                      ),

                      /// middle part
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  capitalizeWord(user.name),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontSize: SizingConfig.textMultiplier * 1.8,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(
                                  width: SizingConfig.widthMultiplier * 2.0,
                                ),
                                Text(userInfo!,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColor.accent,
                                    fontSize: SizingConfig.textMultiplier * 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizingConfig.heightMultiplier * .5,
                            ),
                            Text(
                              notification.message,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: SizingConfig.textMultiplier * 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// end part
                      Text(
                        timeAgo(notification.createdAt!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: SizingConfig.textMultiplier * 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
