import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/fund_cluster.dart';
import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/enums/unit.dart' as unit;
import '../../../../core/error/failure.dart';
import '../entities/paginated_purchase_request_result.dart';
import '../entities/purchase_request.dart';

abstract interface class PurchaseRequestRepository {
   Future<Either<Failure, PaginatedPurchaseRequestResultEntity>> getPurchaseRequests({
     required int page,
     required int pageSize,
  });

   Future<Either<Failure, PurchaseRequestEntity>> getPurchaseRequestById({
     required String prId,
   });
}