import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../config/routes/app_routing_constants.dart';
import '../../../../../config/sizing/sizing_config.dart';
import '../../../../../config/themes/app_color.dart';
import '../../../../../features/notification/domain/entities/notification.dart';
import '../../../../common/components/custom_circular_loader.dart';
import '../../../../common/components/custom_message_box.dart';
import '../../../../enums/fund_cluster.dart';
import '../../../../enums/unit.dart';
import '../../../../utils/capitalizer.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../utils/readable_enum_converter.dart';
import '../bloc/bloc/purchase_requests_bloc.dart';

class ViewPurchaseRequest extends StatefulWidget {
  const ViewPurchaseRequest({
    super.key,
    required this.prId,
    required this.initLocation,
  });

  final String prId;
  final String
      initLocation; // to determine which to redirect when popping route

  @override
  State<ViewPurchaseRequest> createState() => _ViewPurchaseRequestState();
}

class _ViewPurchaseRequestState extends State<ViewPurchaseRequest>
    with SingleTickerProviderStateMixin {
  late PurchaseRequestsBloc _purchaseRequestsBloc;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _purchaseRequestsBloc = context.read<PurchaseRequestsBloc>();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _purchaseRequestsBloc.add(
      GetPurchaseRequestByIdEvent(
        prId: widget.prId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseRequestsBloc, PurchaseRequestsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizingConfig.widthMultiplier * 5.0,
                        vertical: SizingConfig.heightMultiplier * 3.0,
                      ),
                      child: Column(
                        children: [
                          if (state is PurchaseRequestsLoading)
                            _buildLoadingStateView(),
                          if (state is PurchaseRequestsError)
                            CustomMessageBox.error(
                              message: state.message,
                            ),
                          if (state is PurchaseRequestLoaded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Purchase Request',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize:
                                            SizingConfig.textMultiplier * 3.8,
                                        //fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 2.0,
                                ),
                                _buildInitialPurchaseRequestInformation(
                                  prId: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .id,
                                  entityName: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .entity
                                      .name,
                                  fundCluster: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .fundCluster,
                                  officeName: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .officeEntity
                                      .officeName,
                                  responsibilityCenterCode: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .responsibilityCenterCode,
                                  date: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .date,
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 2.5,
                                ),
                                _buildRequestedItemSection(
                                  itemName: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .productNameEntity
                                      .name,
                                  description: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .productDescriptionEntity
                                      .description!,
                                  unit: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .unit,
                                  quantity: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .quantity,
                                  unitCost: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .unitCost,
                                  totalCost: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .totalCost,
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 2.5,
                                ),
                                _buildPurposeSection(
                                  purpose: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .purpose,
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 2.5,
                                ),
                                _buildOfficerSection(
                                  title: 'Requesting Officer',
                                  name: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .requestingOfficerEntity
                                      .name,
                                  office: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .requestingOfficerEntity
                                      .officeName,
                                  position: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .requestingOfficerEntity
                                      .positionName,
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 2.5,
                                ),
                                _buildOfficerSection(
                                  title: 'Requesting Officer',
                                  name: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .approvingOfficerEntity
                                      .name,
                                  office: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .approvingOfficerEntity
                                      .officeName,
                                  position: state
                                      .purchaseRequestWithNotificationTrailEntity
                                      .purchaseRequestEntity
                                      .approvingOfficerEntity
                                      .positionName,
                                ),
                                SizedBox(
                                  height: SizingConfig.heightMultiplier * 5.0,
                                ),
                                SizedBox(
                                  height: 500.0,
                                  child: _buildTimeline(
                                    notifications: state
                                        .purchaseRequestWithNotificationTrailEntity
                                        .notificationEntities,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingStateView() {
    return Center(
      child: Column(
        children: [
          const CustomCircularLoader(),
          Text(
            'Fetching purchase request...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 1.8,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              tabs: [
                Tab(text: 'Purchase Request Information'),
                Tab(text: 'Track Purchase Request'),
              ],
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(20.0),
            height: 500.0,
            width: double.maxFinite,
            child: TabBarView(
              controller: _tabController,
              children: [Text('Wuwa numba wan')],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialPurchaseRequestInformation({
    required String prId,
    required String entityName,
    required FundCluster fundCluster,
    required String officeName,
    String? responsibilityCenterCode,
    required DateTime date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PR No. $prId',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 2.3,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * .5,
        ),
        Text(
          entityName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * .5,
        ),
        Text(
          readableEnumConverter(fundCluster),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * .5,
        ),
        Text(
          capitalizeWord(officeName),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * .5,
        ),
        if (responsibilityCenterCode != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                responsibilityCenterCode,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: SizingConfig.textMultiplier * 1.8,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * .5,
              ),
            ],
          ),
        Text(
          dateFormatter(date),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  Widget _buildRequestedItemSection({
    required String itemName,
    required String description,
    required Unit unit,
    required int quantity,
    required double unitCost,
    required double totalCost,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          capitalizeWord(description),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          readableEnumConverter(unit),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          'QTY: $quantity',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          'UNIT COST: $unitCost',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          'TOTAL: $totalCost',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ],
    );
  }

  Widget _buildPurposeSection({
    required String purpose,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Purpose:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 2.3,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          purpose,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ],
    );
  }

  Widget _buildOfficerSection({
    required String title,
    required String name,
    required String office,
    required String position,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$title:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 2.3,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          capitalizeWord(name),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
        Text(
          capitalizeWord('$office - $position'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: SizingConfig.textMultiplier * 1.8,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  Widget _buildTimeline({required List<NotificationEntity> notifications}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Request Timeline:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 3.8,
                //fontWeight: FontWeight.w600,
              ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isFirst = index == 0 ? true : false;
              final isLast = index == notifications.length - 1 ? true : false;
              print('index: $index - first? $isFirst : last? $isLast');

              return _timelineTile(
                isFirst: isFirst,
                isLast: isLast,
                isPast: true,
                title: readableEnumConverter(notification.type),
                message: notification.message,
                date: notification.createdAt!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _timelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isPast,
    required String title,
    required String message,
    required DateTime date,
  }) {
    return SizedBox(
      height: 200.0,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        isFirst: isFirst,
        isLast: isLast,
        lineXY: 0.2,
        indicatorStyle: IndicatorStyle(
          width: isLast ? 20.0 : 10.0,
          height: isLast ? 20.0 : 10.0,
          color: isLast ? AppColor.accent : AppColor.accent.withOpacity(0.8),
          iconStyle: isLast
              ? IconStyle(
                  iconData: Icons.done,
                  color: AppColor.lightPrimary,
                  fontSize: 16.0,
                )
              : null,
        ),
        beforeLineStyle: LineStyle(
          color: Theme.of(context).dividerColor.withOpacity(.5),
          thickness: 1.3,
        ),
        // afterLineStyle: isLast
        //     ? LineStyle(
        //   color: Theme.of(context).dividerColor.withOpacity(.5),
        //   thickness: 1.3,
        // )
        //     : null,
        startChild: _eventDate(date: date),
        endChild: _eventCard(
          isLast: isLast,
          isPast: isPast,
          title: title,
          message: message,
          date: date,
        ),
      ),
    );
  }

  Widget _eventDate({
    required DateTime date,
  }) {
    return Text(
      dateFormatter(
        date,
      ),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: SizingConfig.textMultiplier * 1.5,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget _eventCard({
    required bool isLast,
    required bool isPast,
    required String title,
    required String message,
    required DateTime date,
  }) {
    // Regular expression to find the tracking ID pattern
    print('raw msg: $message');
    final RegExp regExp = RegExp(r'Tracking ID:\s([A-Z]{3}-\d{4}-\d{2}-\d+)');
    final match = regExp.firstMatch(message);

    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 2.3,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * .5,
          ),
          // Use RichText if a tracking ID is found
          match != null
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.substring(0, match.start),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: SizingConfig.textMultiplier * 1.8,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Action to take when the tracking ID is clicked
                          print("Tracking ID clicked: ${match.group(1)}");
                          // Add your navigation or issuance view logic here
                          final Map<String, dynamic> extra = {
                            'issuance_id': match.group(1),
                          };

                          if (widget.initLocation ==
                              RoutingConstants
                                  .nestedHomePurchaseRequestViewRoutePath) {
                            context.go(
                              RoutingConstants.nestedHomeIssuanceViewRoutePath,
                              extra: extra,
                            );
                          }

                          if (widget.initLocation ==
                              RoutingConstants
                                  .nestedHistoryPurchaseRequestViewRoutePath) {
                            context.go(
                              RoutingConstants
                                  .nestedHistoryIssuanceViewRoutePath,
                              extra: extra,
                            );
                          }
                        },
                        child: Text(
                          'Tracking ID: ${match.group(1)!}.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.accent,
                                    fontSize: SizingConfig.textMultiplier * 1.8,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      // ),
                      // Text(
                      //   message.substring(match.end),
                      //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //         fontSize: SizingConfig.textMultiplier * 1.8,
                      //         fontWeight: FontWeight.w400,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      ),
                    ],
                  ),

                  // RichText(
                  //   text: TextSpan(
                  //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //           fontSize: SizingConfig.textMultiplier * 1.8,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //     children: [
                  //       // Part of the message before the tracking ID
                  //       TextSpan(
                  //         text: message.substring(0, match.start),
                  //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //           fontSize: SizingConfig.textMultiplier * 1.8,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //       ),
                  //       // Tracking ID as a clickable link
                  //       TextSpan(
                  //         text: match.group(1), // The tracking ID
                  //         style:
                  //             Theme.of(context).textTheme.bodySmall?.copyWith(
                  //                   color: AppColor.accent,
                  //                   decoration: TextDecoration.underline,
                  //                   decorationColor: AppColor.accent,
                  //                   fontSize: SizingConfig.textMultiplier * 1.8,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             // Action to take when the tracking ID is clicked
                  //             print("Tracking ID clicked: ${match.group(1)}");
                  //             // Add your navigation or issuance view logic here
                  //             final Map<String, dynamic> extra = {
                  //               'issuance_id': match.group(1),
                  //             };
                  //
                  //             if (widget.initLocation == RoutingConstants.nestedHomePurchaseRequestViewRoutePath) {
                  //               context.go(
                  //                 RoutingConstants.nestedHomeIssuanceViewRoutePath,
                  //                 extra: extra,
                  //               );
                  //             }
                  //
                  //             if (widget.initLocation == RoutingConstants.nestedHistoryPurchaseRequestViewRoutePath) {
                  //               context.go(
                  //                 RoutingConstants.nestedHistoryIssuanceViewRoutePath,
                  //                 extra: extra,
                  //               );
                  //             }
                  //           },
                  //       ),
                  //       // Part of the message after the tracking ID
                  //       TextSpan(
                  //         text: message.substring(match.end),
                  //         style:
                  //             Theme.of(context).textTheme.bodySmall?.copyWith(
                  //                   fontSize: SizingConfig.textMultiplier * 1.8,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                )
              // Display plain message if no tracking ID is found
              : Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: SizingConfig.textMultiplier * 1.8,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
        ],
      ),
    );
  }
}
