import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/purchase_request.dart';
import '../../../domain/usecases/get_paginated_purchase_requests.dart';
import '../../../domain/usecases/get_purchase_request_by_id.dart';

part 'purchase_requests_event.dart';
part 'purchase_requests_state.dart';

class PurchaseRequestsBloc
    extends Bloc<PurchaseRequestsEvent, PurchaseRequestsState> {
  PurchaseRequestsBloc({
    required GetPaginatedPurchaseRequests getPaginatedPurchaseRequests,
    required GetPurchaseRequestById getPurchaseRequestById,
  })  : _getPaginatedPurchaseRequests = getPaginatedPurchaseRequests,
        _getPurchaseRequestById = getPurchaseRequestById,
        super(PurchaseRequestsInitial()) {
    on<GetPurchaseRequestsEvent>(_onGetPurchaseRequests);
    on<GetPurchaseRequestByIdEvent>(_onGetPurchaseRequestById);
  }

  final GetPaginatedPurchaseRequests _getPaginatedPurchaseRequests;
  final GetPurchaseRequestById _getPurchaseRequestById;

  void _onGetPurchaseRequests(
    GetPurchaseRequestsEvent event,
    Emitter<PurchaseRequestsState> emit,
  ) async {
    emit(PurchaseRequestsLoading());

    final response = await _getPaginatedPurchaseRequests(
      GetPaginatedPurchaseRequestsParams(
        page: event.page,
        pageSize: event.pageSize,
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
          totalIncompletePurchaseRequestsCount: r.incompletePurchaseRequestsCount,
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
            purchaseRequest: r,
          ),
        );
      },
    );
  }
}
