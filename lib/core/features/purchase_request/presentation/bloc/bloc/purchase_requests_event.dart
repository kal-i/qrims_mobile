part of 'purchase_requests_bloc.dart';

sealed class PurchaseRequestsEvent extends Equatable {
  const PurchaseRequestsEvent();

  @override
  List<Object?> get props => [];
}

final class GetPurchaseRequestsEvent extends PurchaseRequestsEvent {
  const GetPurchaseRequestsEvent({
    required this.page,
    required this.pageSize,
    this.prId,
    this.status,
    this.filter,
  });

  final int page;
  final int pageSize;
  final String? prId;
  final PurchaseRequestStatus? status;
  final String? filter;

  @override
  List<Object?> get props => [
        page,
        pageSize,
        status,
        filter,
      ];
}

final class GetPurchaseRequestByIdEvent extends PurchaseRequestsEvent {
  const GetPurchaseRequestByIdEvent({
    required this.prId,
  });

  final String prId;
}
