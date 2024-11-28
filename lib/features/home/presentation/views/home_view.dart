import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../core/common/components/custom_circular_loader.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/pagination_controls.dart';
import '../../../../core/common/components/highlight_status_container.dart';
import '../../../../core/common/components/profile_avatar.dart';
import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/features/purchase_request/presentation/bloc/bloc/purchase_requests_bloc.dart';
import '../../../../core/features/purchase_request/presentation/components/purchase_request_card.dart';
import '../../../../core/models/purchase_request/purchase_request.dart';
import '../../../../core/models/user/mobile_user.dart';
import '../../../../core/models/user/user.dart';
import '../../../../core/utils/capitalizer.dart';
import '../../../../core/utils/delightful_toast_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../components/summary_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PurchaseRequestsBloc _purchaseRequestsBloc;

  final List<PurchaseRequestModel> _purchaseRequests = [];
  final ValueNotifier<int> _pendingPurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _incompletePurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _completePurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _cancelledPurchaseRequestsCount = ValueNotifier(0);

  int _currentPage = 1;
  int _pageSize = 2;
  int _totalRecords = 0;
  final String _filter = 'ongoing';

  @override
  void initState() {
    super.initState();
    _purchaseRequestsBloc = context.read<PurchaseRequestsBloc>();
    _fetchPurchaseRequests();
  }

  void _fetchPurchaseRequests() {
    _purchaseRequestsBloc.add(
      GetPurchaseRequestsEvent(
        page: _currentPage,
        pageSize: _pageSize,
        filter: _filter,
      ),
    );
  }

  void _refreshPurchaseRequestList() {
    _currentPage = 1;
    _fetchPurchaseRequests();
  }

  void _onViewPurchaseRequest(String prId) {
    final Map<String, dynamic> extra = {
      'pr_id': prId,
      'init_location': RoutingConstants.nestedHomePurchaseRequestViewRoutePath,
    };

    context.go(
      RoutingConstants.nestedHomePurchaseRequestViewRoutePath,
      extra: extra,
    );
  }

  void _onFollowUpPurchaseRequest(String prId) {
    _purchaseRequestsBloc.add(
      FollowUpPurchaseRequestEvent(
        prId: prId,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pendingPurchaseRequestsCount.dispose();
    _incompletePurchaseRequestsCount.dispose();
    _completePurchaseRequestsCount.dispose();
    _cancelledPurchaseRequestsCount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizingConfig.widthMultiplier * 5.0,
            vertical: SizingConfig.heightMultiplier * 3.0,
          ),
          child: Column(
            children: [
              _buildHeaderRow(),
              SizedBox(
                height: SizingConfig.heightMultiplier * 3.0,
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * 23.0,
                child: _buildSummaryReportsContainer(),
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * 3.0,
              ),
              Expanded(
                child: _buildPurchaseRequestsViewSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Default placeholder values
        String userName = "Guest";
        MobileUserModel? _user;

        // if (state is AuthSuccess<UserModel>) {
        //   user = state.data;
        //   userName = capitalizeWord(user.name.toString().split(' ').last);
        // }

        if (state is AuthSuccess) {
          _user = MobileUserModel.fromEntity(state.data);
        }

        if (state is UserInfoUpdated) {
          _user = MobileUserModel.fromEntity(state.updatedUser);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  capitalizeWord(_user!.name.toString().split(' ').last),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            ProfileAvatar(
              user: _user, // Ensure ProfileAvatar gracefully handles null values
            ),
          ],
        );
      },
    );
  }


  // Widget _buildHeaderRow() {
  //   return BlocBuilder<AuthBloc, AuthState>(
  //     builder: (context, state) {
  //       late MobileUserModel user;
  //       if (state is AuthSuccess) {
  //         user = state.data;
  //       }
  //
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Welcome back,',
  //                 style: Theme.of(context).textTheme.titleSmall,
  //               ),
  //               Text(
  //                 capitalizeWord(user.name.toString().split(' ').last),
  //                 style: Theme.of(context).textTheme.titleMedium,
  //               ),
  //             ],
  //           ),
  //           ProfileAvatar(
  //             user: user,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildSummaryReportsContainer() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _completePurchaseRequestsCount,
                    builder: (context, completeCount, child) {
                      return SummaryCard(
                        label: 'Fulfilled',
                        value: completeCount.toString(),
                        icon: HugeIcons.strokeRoundedPackageDelivered,
                        background: AppColor.lightGreen,
                        outlineColor: AppColor.lightGreenOutline,
                        foreground: AppColor.lightGreenText,
                      );
                    }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _incompletePurchaseRequestsCount,
                    builder: (context, incompleteCount, child) {
                      return SummaryCard(
                        label: 'Semi-Fulfilled',
                        value: incompleteCount.toString(),
                        icon: HugeIcons.strokeRoundedPackageRemove,
                        background: AppColor.lightBlue,
                        outlineColor: AppColor.lightBlueOutline,
                        foreground: AppColor.lightBlueText,
                      );
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _pendingPurchaseRequestsCount,
                    builder: (context, pendingCount, child) {
                      return SummaryCard(
                        label: 'Pending',
                        value: pendingCount.toString(),
                        icon: HugeIcons.strokeRoundedPackageProcess,
                        background: AppColor.lightYellow,
                        outlineColor: AppColor.lightYellowOutline,
                        foreground: AppColor.lightYellowText,
                      );
                    }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _cancelledPurchaseRequestsCount,
                    builder: (context, cancelledCount, child) {
                      return SummaryCard(
                        label: 'Cancelled',
                        value: cancelledCount.toString(),
                        icon: HugeIcons.strokeRoundedPackageRemove,
                        background: AppColor.lightRed,
                        outlineColor: AppColor.lightRedOutline,
                        foreground: AppColor.lightRedText,
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseRequestsViewSectionHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ongoing Requests',
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
                _fetchPurchaseRequests();
              },
              onPageSizeChanged: (size) {
                _pageSize = size;
                _fetchPurchaseRequests();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPurchaseRequestsViewSection() {
    return BlocListener<PurchaseRequestsBloc, PurchaseRequestsState>(
      listener: (context, state) {
        if (state is PurchaseRequestsLoaded) {
          _totalRecords = state.totalPurchaseRequestsCount;
          _pendingPurchaseRequestsCount.value =
              state.totalPendingPurchaseRequestsCount;
          _incompletePurchaseRequestsCount.value =
              state.totalIncompletePurchaseRequestsCount;
          _completePurchaseRequestsCount.value =
              state.totalCompletePurchaseRequestsCount;
          _cancelledPurchaseRequestsCount.value =
              state.totalCancelledPurchaseRequestsCount;
          _purchaseRequests.clear();
          _purchaseRequests.addAll(
            state.purchaseRequests
                .map((pr) => pr as PurchaseRequestModel)
                .toList(),
          );
        }

        if (state is PurchaseRequestFollowedUp) {
          DelightfulToastUtils.showDelightfulToast(
            context: context,
            icon: HugeIcons.strokeRoundedNotificationSquare,
            title: 'Followed up',
            subtitle: state.message,
          );
        }

        if (state is PurchaseRequestFollowUpError) {
          DelightfulToastUtils.showDelightfulToast(
            context: context,
            icon: HugeIcons.strokeRoundedNotificationSquare,
            title: 'Follow Up Error',
            subtitle: state.message,
          );
        }
      },
      child: BlocBuilder<PurchaseRequestsBloc, PurchaseRequestsState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildPurchaseRequestsViewSectionHeader(),
              SizedBox(
                height: SizingConfig.heightMultiplier * 2.5,
              ),
              if (state is PurchaseRequestsLoading)
                const CustomCircularLoader(),
              if (state is PurchaseRequestsError)
                CustomMessageBox.error(
                  message: state.message,
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refreshPurchaseRequestList(),
                  child: ListView.builder(
                    itemCount: _purchaseRequests.length,
                    itemBuilder: (context, index) {
                      final pr = _purchaseRequests[index];

                      return PurchaseRequestCard(
                        onView: (_) => _onViewPurchaseRequest(pr.id),
                        onNotify: (_) => _onFollowUpPurchaseRequest(pr.id),
                        prId: pr.id,
                        itemName: pr.productNameEntity.name,
                        purpose: pr.purpose,
                        date: pr.date,
                        highlightStatusContainer: _buildStatusHighlighter(
                          pr.purchaseRequestStatus,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusHighlighter(PurchaseRequestStatus prStatus) {
    return HighlightStatusContainer(
      statusStyle: _prStatusStyler(prStatus: prStatus),
    );
  }

  StatusStyle _prStatusStyler({
    required PurchaseRequestStatus prStatus,
  }) {
    switch (prStatus) {
      case PurchaseRequestStatus.pending:
        return StatusStyle.yellow(label: 'Pending');
      case PurchaseRequestStatus.partiallyFulfilled:
        return StatusStyle.blue(label: 'Incomplete');
      case PurchaseRequestStatus.fulfilled:
        return StatusStyle.green(label: 'Complete');
      case PurchaseRequestStatus.cancelled:
        return StatusStyle.red(label: 'Cancelled');
      default:
        throw Exception('Invalid Purchase Request Status');
    }
  }
}
