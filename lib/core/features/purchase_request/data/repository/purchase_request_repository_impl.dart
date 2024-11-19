import 'package:fpdart/fpdart.dart';

import '../../../../entities/purchase_request/paginated_purchase_request_result.dart';
import '../../../../entities/purchase_request/purchase_request_with_notification_trail.dart';
import '../../../../enums/purchase_request_status.dart';
import '../../../../error/exceptions.dart';
import '../../../../error/failure.dart';
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
    PurchaseRequestStatus? status,
    String? filter,
  }) async {
    try {
      final response =
          await purchaseRequestRemoteDataSource.getPurchaseRequests(
        page: page,
        pageSize: pageSize,
        prId: prId,
        filter: filter,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PurchaseRequestWithNotificationTrailEntity>>
      getPurchaseRequestById({
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

  @override
  Future<Either<Failure, String>> followUpPurchaseRequest({
    required String prId,
  }) async {
    try {
      final response =
          await purchaseRequestRemoteDataSource.followUpPurchaseRequest(
        prId: prId,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
