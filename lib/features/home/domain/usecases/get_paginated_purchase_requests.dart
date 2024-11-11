import 'package:fpdart/src/either.dart';

import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paginated_purchase_request_result.dart';
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
    );
  }
}

class GetPaginatedPurchaseRequestsParams {
  const GetPaginatedPurchaseRequestsParams({
    required this.page,
    required this.pageSize,
  });

  final int page;
  final int pageSize;
}
