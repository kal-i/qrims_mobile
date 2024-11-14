import 'package:fpdart/fpdart.dart';

import '../../../../entities/purchase_request/paginated_purchase_request_result.dart';
import '../../../../entities/purchase_request/purchase_request_with_notification_trail.dart';
import '../../../../enums/purchase_request_status.dart';
import '../../../../error/failure.dart';

abstract interface class PurchaseRequestRepository {
   Future<Either<Failure, PaginatedPurchaseRequestResultEntity>> getPurchaseRequests({
     required int page,
     required int pageSize,
     String? prId,
     PurchaseRequestStatus? status,
     String? filter,
  });

   Future<Either<Failure, PurchaseRequestWithNotificationTrailEntity>> getPurchaseRequestById({
     required String prId,
   });
}