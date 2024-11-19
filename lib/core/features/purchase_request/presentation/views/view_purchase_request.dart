import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routes/app_routing_constants.dart';
import '../../../../../config/sizing/sizing_config.dart';
import '../../../../../features/notification/domain/entities/notification.dart';
import '../../../../common/components/custom_circular_loader.dart';
import '../../../../common/components/custom_message_box.dart';
import '../../../../models/org/officer.dart';
import '../../../../models/purchase_request/purchase_request.dart';
import '../../../../utils/capitalizer.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../utils/readable_enum_converter.dart';
import '../bloc/bloc/purchase_requests_bloc.dart';
import '../components/request_time_line_tile.dart';

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

class _ViewPurchaseRequestState extends State<ViewPurchaseRequest> {
  late PurchaseRequestsBloc _purchaseRequestsBloc;

  @override
  void initState() {
    super.initState();
    _purchaseRequestsBloc = context.read<PurchaseRequestsBloc>();
    _fetchPurchaseRequest();
  }

  void _fetchPurchaseRequest() {
    _purchaseRequestsBloc.add(
      GetPurchaseRequestByIdEvent(
        prId: widget.prId,
      ),
    );
  }

  void _onTrackingIdTapped(BuildContext context, String trackingId) {
    print('tracking id: $trackingId');
    final Map<String, dynamic> extra = {
      'issuance_id': trackingId.toString().split(' ').last,
    };

    if (widget.initLocation ==
        RoutingConstants.nestedHomePurchaseRequestViewRoutePath) {
      context.go(RoutingConstants.nestedHomeIssuanceViewRoutePath,
          extra: extra);
    }

    if (widget.initLocation ==
        RoutingConstants.nestedHistoryPurchaseRequestViewRoutePath) {
      context.go(RoutingConstants.nestedHistoryIssuanceViewRoutePath,
          extra: extra);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: BlocBuilder<PurchaseRequestsBloc, PurchaseRequestsState>(
                    builder: (context, state) {
                      return _buildMainView(
                        state,
                      );
                    }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView(PurchaseRequestsState state) {
    if (state is PurchaseRequestsLoading) {
      return _buildLoadingStateView();
    }

    if (state is PurchaseRequestsError) {
      return CustomMessageBox.error(message: state.message,);
    }

    if (state is PurchaseRequestLoaded) {
      return _buildRequestDetails(state,);
    }

    return const SizedBox.shrink();
  }

  Widget _buildRequestDetails(PurchaseRequestLoaded state) {
    final purchaseRequest =
        state.purchaseRequestWithNotificationTrailEntity.purchaseRequestEntity;
    final requestingOfficer = purchaseRequest.requestingOfficerEntity;
    final approvingOfficer = purchaseRequest.approvingOfficerEntity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.0,
        ),
        _buildPurchaseRequestInfo(
          purchaseRequest as PurchaseRequestModel,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.5,
        ),
        _buildRequestedItemSection(
          purchaseRequest,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.5,
        ),
        _buildPurposeSection(
          purchaseRequest.purpose,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.5,
        ),
        _buildOfficerSection(
          'Requesting Officer',
          requestingOfficer as OfficerModel,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.5,
        ),
        _buildOfficerSection(
          'Approving Officer',
          approvingOfficer as OfficerModel,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 5.0,
        ),
        SizedBox(
          height: 500.0,
          child: _buildTimeline(
            state.purchaseRequestWithNotificationTrailEntity
                .notificationEntities,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Purchase Request',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: SizingConfig.textMultiplier * 3.8,
          ),
    );
  }

  Widget _buildPurchaseRequestInfo(PurchaseRequestModel purchaseRequest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfoText(
          'PR No. ${purchaseRequest.id}',
        ),
        _buildInfoText(purchaseRequest.entity.name),
        _buildInfoText(
          readableEnumConverter(
            purchaseRequest.fundCluster,
          ),
        ),
        _buildInfoText(
          capitalizeWord(
            purchaseRequest.officeEntity.officeName,
          ),
        ),
        if (purchaseRequest.responsibilityCenterCode != null)
          _buildInfoText(
            purchaseRequest.responsibilityCenterCode!,
          ),
        _buildInfoText(
          dateFormatter(
            purchaseRequest.date,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizingConfig.heightMultiplier * 0.5,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: SizingConfig.textMultiplier * 1.8,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }

  Widget _buildRequestedItemSection(PurchaseRequestModel purchaseRequest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleSection(
          'Item Details',
        ),
        _buildInfoText(
          capitalizeWord(
            purchaseRequest.productNameEntity.name,
          ),
        ),
        _buildInfoText(
            purchaseRequest.productDescriptionEntity.description ?? ''),
        _buildInfoText(
          readableEnumConverter(
            purchaseRequest.unit,
          ),
        ),
        _buildInfoText(
          'QTY: ${purchaseRequest.quantity}',
        ),
        _buildInfoText(
          'UNIT COST: ${purchaseRequest.unitCost}',
        ),
        _buildInfoText(
          'TOTAL: ${purchaseRequest.totalCost}',
        ),
      ],
    );
  }

  Widget _buildTitleSection(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: SizingConfig.textMultiplier * 2.3,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildPurposeSection(String purpose) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleSection(
          'Purpose:',
        ),
        _buildInfoText(
          purpose,
        ),
      ],
    );
  }

  Widget _buildOfficerSection(String title, OfficerModel officer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleSection(
          title,
        ),
        _buildInfoText(
          capitalizeWord(
            officer.name,
          ),
        ),
        _buildInfoText(
          capitalizeWord(
            '${officer.officeName} - ${officer.positionName}',
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(List<NotificationEntity> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleSection('Request Timeline:'),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isFirst = index == 0 ? true : false;
              final isLast = index == notifications.length - 1 ? true : false;

              return RequestTimeLineTile(
                isFirst: isFirst,
                isLast: isLast,
                isPast: true,
                title: readableEnumConverter(notification.type),
                message: notification.message,
                date: notification.createdAt!,
                onTrackingIdTapped: (trackingId) =>
                    _onTrackingIdTapped(context, trackingId),
              );
            },
          ),
        ),
      ],
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
}
