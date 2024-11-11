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
  });

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [
        page,
        pageSize,
      ];
}

final class GetPurchaseRequestByIdEvent extends PurchaseRequestsEvent {
  const GetPurchaseRequestByIdEvent({
    required this.prId,
  });

  final String prId;
}
