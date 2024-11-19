import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../entities/purchase_request/purchase_request.dart';
import '../../../../../entities/purchase_request/purchase_request_with_notification_trail.dart';
import '../../../../../enums/purchase_request_status.dart';
import '../../../domain/usecases/follow_up_purchase_request.dart';
import '../../../domain/usecases/get_paginated_purchase_requests.dart';
import '../../../domain/usecases/get_purchase_request_by_id.dart';

part 'purchase_requests_event.dart';
part 'purchase_requests_state.dart';

class PurchaseRequestsBloc
    extends Bloc<PurchaseRequestsEvent, PurchaseRequestsState> {
  PurchaseRequestsBloc({
    required GetPaginatedPurchaseRequests getPaginatedPurchaseRequests,
    required GetPurchaseRequestById getPurchaseRequestById,
    required FollowUpPurchaseRequest followUpPurchaseRequest,
  })  : _getPaginatedPurchaseRequests = getPaginatedPurchaseRequests,
        _getPurchaseRequestById = getPurchaseRequestById,
        _followUpPurchaseRequest = followUpPurchaseRequest,
        super(PurchaseRequestsInitial()) {
    on<GetPurchaseRequestsEvent>(_onGetPurchaseRequests);
    on<GetPurchaseRequestByIdEvent>(_onGetPurchaseRequestById);
    on<FollowUpPurchaseRequestEvent>(_onFollowUpPurchaseRequest);
  }

  final GetPaginatedPurchaseRequests _getPaginatedPurchaseRequests;
  final GetPurchaseRequestById _getPurchaseRequestById;
  final FollowUpPurchaseRequest _followUpPurchaseRequest;

  void _onGetPurchaseRequests(
    GetPurchaseRequestsEvent event,
    Emitter<PurchaseRequestsState> emit,
  ) async {
    emit(PurchaseRequestsLoading());

    final response = await _getPaginatedPurchaseRequests(
      GetPaginatedPurchaseRequestsParams(
        page: event.page,
        pageSize: event.pageSize,
        prId: event.prId,
        status: event.status,
        filter: event.filter,
      ),
    );

    response.fold(
      (l) => emit(
        PurchaseRequestsError(
          message: l.message,
        ),
      ),
      (r) => emit(
        PurchaseRequestsLoaded(
          purchaseRequests: r.purchaseRequests,
          totalPurchaseRequestsCount: r.totalItemsCount,
          totalPendingPurchaseRequestsCount: r.pendingPurchaseRequestsCount,
          totalIncompletePurchaseRequestsCount:
              r.incompletePurchaseRequestsCount,
          totalCompletePurchaseRequestsCount: r.completePurchaseRequestsCount,
          totalCancelledPurchaseRequestsCount: r.cancelledPurchaseRequestsCount,
        ),
      ),
    );
  }

  void _onGetPurchaseRequestById(
    GetPurchaseRequestByIdEvent event,
    Emitter<PurchaseRequestsState> emit,
  ) async {
    emit(PurchaseRequestsLoading());

    final response = await _getPurchaseRequestById(event.prId);

    response.fold(
      (l) => emit(
        PurchaseRequestsError(
          message: l.message,
        ),
      ),
      (r) {
        emit(
          PurchaseRequestLoaded(
            purchaseRequestWithNotificationTrailEntity: r,
          ),
        );
      },
    );
  }

  void _onFollowUpPurchaseRequest(
    FollowUpPurchaseRequestEvent event,
    Emitter<PurchaseRequestsState> emit,
  ) async {
    emit(PurchaseRequestsLoading());

    final response = await _followUpPurchaseRequest(event.prId);

    response.fold(
      (l) => emit(
        PurchaseRequestFollowUpError(
          message: l.message,
        ),
      ),
      (r) {
        emit(
          PurchaseRequestFollowedUp(
            message: r,
          ),
        );
      },
    );
  }
}
