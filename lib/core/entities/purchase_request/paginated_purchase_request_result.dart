import 'purchase_request.dart';

class PaginatedPurchaseRequestResultEntity {
  const PaginatedPurchaseRequestResultEntity({
    required this.purchaseRequests,
    required this.totalItemsCount,
    required this.pendingPurchaseRequestsCount,
    required this.incompletePurchaseRequestsCount,
    required this.completePurchaseRequestsCount,
    required this.cancelledPurchaseRequestsCount,
  });

  final List<PurchaseRequestEntity> purchaseRequests;
  final int totalItemsCount;
  final int pendingPurchaseRequestsCount;
  final int incompletePurchaseRequestsCount;
  final int completePurchaseRequestsCount;
  final int cancelledPurchaseRequestsCount;
}
