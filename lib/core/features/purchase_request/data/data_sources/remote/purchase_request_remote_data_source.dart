import '../../../../../enums/purchase_request_status.dart';
import '../../../../../models/purchase_request/paginated_purchase_request_result.dart';
import '../../../../../models/purchase_request/purchase_request_with_notification_trail.dart';

abstract interface class PurchaseRequestRemoteDataSource {
  Future<PaginatedPurchaseRequestResultModel> getPurchaseRequests({
    required int page,
    required int pageSize,
    String? prId,
    PurchaseRequestStatus? status,
    String? filter,
  });

  Future<PurchaseRequestWithNotificationTrailModel> getPurchaseRequestById({
    required String prId,
  });
}