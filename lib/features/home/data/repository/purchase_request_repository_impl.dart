import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/fund_cluster.dart';
import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/enums/unit.dart' as unit;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/paginated_purchase_request_result.dart';
import '../../domain/entities/purchase_request.dart';
import '../../domain/repository/purchase_request_repository.dart';
import '../data_sources/remote/purchase_request_remote_data_source.dart';

class PurchaseRequestRepositoryImpl implements PurchaseRequestRepository {
  const PurchaseRequestRepositoryImpl({
    required this.purchaseRequestRemoteDataSource,
  });

  final PurchaseRequestRemoteDataSource purchaseRequestRemoteDataSource;

  @override
  Future<Either<Failure, PaginatedPurchaseRequestResultEntity>>
      getPurchaseRequests({
    required int page,
    required int pageSize,
    String? prId,
    double? unitCost,
    DateTime? date,
    PurchaseRequestStatus? prStatus,
    bool? isArchived,
  }) async {
    try {
      final response =
          await purchaseRequestRemoteDataSource.getPurchaseRequests(
        page: page,
        pageSize: pageSize,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PurchaseRequestEntity>> getPurchaseRequestById({
    required String prId,
  }) async {
    try {
      final response =
          await purchaseRequestRemoteDataSource.getPurchaseRequestById(
        prId: prId,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
