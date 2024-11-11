import '../../domain/entities/paginated_purchase_request_result.dart';
import 'purchase_request.dart';

class PaginatedPurchaseRequestResultModel
    extends PaginatedPurchaseRequestResultEntity {
  const PaginatedPurchaseRequestResultModel({
    required super.purchaseRequests,
    required super.totalItemsCount,
    required super.pendingPurchaseRequestsCount,
    required super.incompletePurchaseRequestsCount,
    required super.completePurchaseRequestsCount,
    required super.cancelledPurchaseRequestsCount,
  });

  factory PaginatedPurchaseRequestResultModel.fromJson(
      Map<String, dynamic> json) {
    return PaginatedPurchaseRequestResultModel(
      purchaseRequests: (json['purchase_requests'] as List<dynamic>)
          .map((e) => PurchaseRequestModel.fromJson(e))
          .toList(),
      totalItemsCount: json['total_item_count'],
      pendingPurchaseRequestsCount: json['pending_count'],
      incompletePurchaseRequestsCount: json['incomplete_count'],
      completePurchaseRequestsCount: json['complete_count'],
      cancelledPurchaseRequestsCount: json['cancelled_count'],
    );
  }
}
