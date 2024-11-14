import 'package:dio/dio.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../enums/purchase_request_status.dart';
import '../../../../../error/dio_exception_formatter.dart';
import '../../../../../error/exceptions.dart';
import '../../../../../models/purchase_request/paginated_purchase_request_result.dart';
import '../../../../../models/purchase_request/purchase_request_with_notification_trail.dart';
import '../../../../../services/http_service.dart';
import 'purchase_request_remote_data_source.dart';

class PurchaseRequestRemoteDataSourceImpl
    implements PurchaseRequestRemoteDataSource {
  const PurchaseRequestRemoteDataSourceImpl({
    required this.httpService,
  });

  final HttpService httpService;

  @override
  Future<PaginatedPurchaseRequestResultModel> getPurchaseRequests({
    required int page,
    required int pageSize,
    String? prId,
    PurchaseRequestStatus? status,
    String? filter,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
        if (prId != null && prId.isNotEmpty) 'pr_id': prId,
        if (status != null) 'pr_status': status.toString().split('.').last,
        if (filter != null && filter.isNotEmpty) 'filter': filter,
      };

      final response = await httpService.get(
        endpoint: requestingOfficerPurchaseRequestsEP,
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedPurchaseRequestResultModel.fromJson(response.data);
      } else {
        throw const ServerException('Failed to fetch purchase requests.');
      }
    } on DioException catch (e) {
      final formattedError = formatDioError(e);
      throw ServerException(formattedError);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PurchaseRequestWithNotificationTrailModel> getPurchaseRequestById({required String prId,}) async {
    try {
      final response = await httpService.get(
        endpoint: '$purchaseRequestIdEP/$prId',
      );

      if (response.statusCode == 200) {
        return PurchaseRequestWithNotificationTrailModel.fromJson(response.data);
      } else {
        throw const ServerException('Failed to fetch purchase request by id.');
      }
    } on DioException catch (e) {
      final formattedError = formatDioError(e);
      throw ServerException(formattedError);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
