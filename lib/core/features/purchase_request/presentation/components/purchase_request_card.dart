import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../config/sizing/sizing_config.dart';
import '../../../../../config/themes/app_color.dart';
import '../../../../common/components/base_container.dart';
import '../../../../common/components/highlight_status_container.dart';
import '../../../../utils/capitalizer.dart';
import '../../../../utils/date_formatter.dart';

class PurchaseRequestCard extends StatelessWidget {
  const PurchaseRequestCard({
    super.key,
    required this.onView,
    required this.onNotify,
    required this.prId,
    required this.itemName,
    required this.purpose,
    required this.date,
    required this.highlightStatusContainer,
  });

  final SlidableActionCallback onView;
  final SlidableActionCallback onNotify;
  final String prId;
  final String itemName;
  final String purpose;
  final DateTime date;
  final Widget highlightStatusContainer;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onView,
            borderRadius: BorderRadius.circular(10.0),
            backgroundColor: AppColor.lightYellow,
            foregroundColor: AppColor.lightYellowText,
            icon: HugeIcons.strokeRoundedView,
            label: 'View',
          ),
          // send some kind of distress signal in a form of notif I guess
          SlidableAction(
            borderRadius: BorderRadius.circular(10.0),
            onPressed: onNotify,
            backgroundColor: AppColor.lightGreen,
            foregroundColor: AppColor.lightGreenText,
            icon: HugeIcons.strokeRoundedSent,
            label: 'Notify',
          ),
        ],
      ),
      child: BaseContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PR #$prId',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: SizingConfig.textMultiplier * 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                highlightStatusContainer,
              ],
            ),
            Text(
              capitalizeWord(
                itemName,
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: SizingConfig.textMultiplier * 2.3,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(
              height: SizingConfig.heightMultiplier * .5,
            ),
            Text(
              purpose,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: SizingConfig.textMultiplier * 1.8,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            SizedBox(
              height: SizingConfig.heightMultiplier * 1.8,
            ),
            Row(
              children: [
                const Icon(
                  HugeIcons.strokeRoundedCalendar03,
                  size: 20.0,
                ),
                SizedBox(
                  width: SizingConfig.widthMultiplier * 0.5,
                ),
                Text(
                  dateFormatter(
                    date,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: SizingConfig.textMultiplier * 1.8,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
