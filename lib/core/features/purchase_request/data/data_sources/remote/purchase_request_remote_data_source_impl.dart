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
  Future<PurchaseRequestWithNotificationTrailModel> getPurchaseRequestById({
    required String prId,
  }) async {
    try {
      final response = await httpService.get(
        endpoint: '$purchaseRequestIdEP/$prId',
      );

      if (response.statusCode == 200) {
        return PurchaseRequestWithNotificationTrailModel.fromJson(
            response.data);
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

  @override
  Future<String> followUpPurchaseRequest({
    required String prId,
  }) async {
    try {
      final response = await httpService.post(
        endpoint: '$purchaseRequestFollowUpEP/$prId',
      );

      // Handle successful follow-up
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] ?? 'Follow-up successful.';
      }

      // Handle specific status codes with informative messages
      if (response.statusCode == 401) {
        final errorData = response.data as Map<String, dynamic>;
        throw ServerException(errorData['error'] ?? 'Unauthorized action.');
      }

      if (response.statusCode == 403) {
        final errorData = response.data as Map<String, dynamic>;
        throw ServerException(errorData['error'] ?? 'Action forbidden.');
      }

      if (response.statusCode == 404) {
        throw const ServerException('Purchase request not found.');
      }

      if (response.statusCode == 500) {
        final errorData = response.data as Map<String, dynamic>;
        throw ServerException(errorData['error'] ?? 'Server error occurred.');
      }

      // Fallback for other unhandled status codes
      throw ServerException(
        'Unexpected error: ${response.statusCode} - ${response.statusMessage}',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage = errorData?['error'] ?? e.response?.statusMessage;

        throw ServerException(
          errorMessage ?? 'An unexpected error occurred.',
        );
      } else {
        throw ServerException('Connection error: ${e.message}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
