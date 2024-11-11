import '../../../../../core/enums/fund_cluster.dart';
import '../../../../../core/enums/purchase_request_status.dart';
import '../../../../../core/enums/unit.dart';
import '../../models/paginated_purchase_request_result.dart';
import '../../models/purchase_request.dart';

abstract interface class PurchaseRequestRemoteDataSource {
  Future<PaginatedPurchaseRequestResultModel> getPurchaseRequests({
    required int page,
    required int pageSize,
  });

  Future<PurchaseRequestModel> getPurchaseRequestById({
    required String prId,
  });
}