import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../core/common/components/custom_circular_loader.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/custom_text_box.dart';
import '../../../../core/common/components/pagination_controls.dart';
import '../../../../core/common/components/highlight_status_container.dart';
import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/features/purchase_request/presentation/bloc/bloc/purchase_requests_bloc.dart';
import '../../../../core/features/purchase_request/presentation/components/purchase_request_card.dart';
import '../../../../core/models/purchase_request/purchase_request.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late PurchaseRequestsBloc _purchaseRequestsBloc;

  final List<PurchaseRequestModel> _purchaseRequests = [];
  final ValueNotifier<int> _pendingPurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _incompletePurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _completePurchaseRequestsCount = ValueNotifier(0);
  final ValueNotifier<int> _cancelledPurchaseRequestsCount = ValueNotifier(0);

  final _searchController = TextEditingController();
  final _searchDelay = const Duration(milliseconds: 500);
  Timer? _debounce;

  int _currentPage = 1;
  int _pageSize = 5;
  int _totalRecords = 0;
  String _filter = 'history';

  @override
  void initState() {
    super.initState();
    _purchaseRequestsBloc = context.read<PurchaseRequestsBloc>();
    _searchController.addListener(_onSearchChanged);
    _fetchPurchaseRequests();
  }

  void _fetchPurchaseRequests() {
    _purchaseRequestsBloc.add(
      GetPurchaseRequestsEvent(
        page: _currentPage,
        pageSize: _pageSize,
        prId: _searchController.text,
        filter: _filter,
        // status: _selectedPrStatus(
        //   selectedPrStatus: _selectedFilterNotifier.value,
        // ),
      ),
    );
  }

  void _refreshPurchaseRequestList() {
    _searchController.clear();
    _debounce?.cancel();
    _currentPage = 1;
    _fetchPurchaseRequests();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_searchDelay, () {
      _currentPage = 1;
      _fetchPurchaseRequests();
    });
  }

  PurchaseRequestStatus _selectedPrStatus({
    required String selectedPrStatus,
  }) {
    switch (selectedPrStatus) {
      case 'pending':
        return PurchaseRequestStatus.pending;
      case 'incomplete':
        return PurchaseRequestStatus.partiallyFulfilled;
      case 'fulfilled':
        return PurchaseRequestStatus.fulfilled;
      case 'cancelled':
        return PurchaseRequestStatus.cancelled;
      default:
        return PurchaseRequestStatus.pending;
    }
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
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

  Widget _buildSearchField() {
    return CustomTextBox(
      controller: _searchController,
      circularBorderRadius: 15.0,
      fillColor: Theme.of(context).primaryColor,
      height: SizingConfig.heightMultiplier * 10.0,
      placeHolderText: 'Search by Id',
      prefixIcon: HugeIcons.strokeRoundedSearch01,
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
                  color: AppColor.accent,
                  child: ListView.builder(
                    itemCount: _purchaseRequests.length,
                    itemBuilder: (context, index) {
                      final pr = _purchaseRequests[index];

                      return PurchaseRequestCard(
                        onView: (_) {
                          final Map<String, dynamic> extra = {
                            'pr_id': pr.id,
                            'init_location': RoutingConstants.nestedHistoryPurchaseRequestViewRoutePath,
                          };

                          context.go(
                            RoutingConstants
                                .nestedHistoryPurchaseRequestViewRoutePath,
                            extra: extra,
                          );
                        },
                        onNotify: (_) {},
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

  Widget _buildPurchaseRequestsViewSectionHeader() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'History',
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

  Widget _buildStatusHighlighter(PurchaseRequestStatus prStatus) {
    return HighlightStatusContainer(
      statusStyle: _prStatusStyler(prStatus: prStatus),
    );
  }

  StatusStyle _prStatusStyler({required PurchaseRequestStatus prStatus}) {
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
