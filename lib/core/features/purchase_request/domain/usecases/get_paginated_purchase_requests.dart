import 'package:fpdart/src/either.dart';

import '../../../../entities/purchase_request/paginated_purchase_request_result.dart';
import '../../../../enums/purchase_request_status.dart';
import '../../../../error/failure.dart';
import '../../../../usecases/usecase.dart';
import '../repository/purchase_request_repository.dart';

class GetPaginatedPurchaseRequests
    implements
        UseCase<PaginatedPurchaseRequestResultEntity,
            GetPaginatedPurchaseRequestsParams> {
  const GetPaginatedPurchaseRequests({
    required this.purchaseRequestRepository,
  });

  final PurchaseRequestRepository purchaseRequestRepository;

  @override
  Future<Either<Failure, PaginatedPurchaseRequestResultEntity>> call(
      GetPaginatedPurchaseRequestsParams params) async {
    return purchaseRequestRepository.getPurchaseRequests(
      page: params.page,
      pageSize: params.pageSize,
      prId: params.prId,
      status: params.status,
      filter: params.filter,
    );
  }
}

class GetPaginatedPurchaseRequestsParams {
  const GetPaginatedPurchaseRequestsParams({
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
}
