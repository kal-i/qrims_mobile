import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ValueNotifier<List<int>> _items = ValueNotifier(List.generate(10, (index) => index + 1));
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_fetchMore);
  }

  Future<void> _fetchMore() async {
    // check if reach the end of the list
    if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
      print('triggered!');
      _items.value.addAll(List.generate(10, (index) => index + 1));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizingConfig.widthMultiplier * 5.0,
          vertical: SizingConfig.heightMultiplier * 3.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildNotificationListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationListView() {
    return ValueListenableBuilder(
      valueListenable: _items,
      builder: (context, items, child) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return _buildNotificationCard(index);
            }

            return SpinKitFadingCircle(
              color: AppColor.accent,
              size: SizingConfig.heightMultiplier * 2.0,
            );
          },
        );
      }
    );
  }

  Widget _buildNotificationCard(int index) {
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
          'PR #$index has been registered to the system.',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          'Admin',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '10/31',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
