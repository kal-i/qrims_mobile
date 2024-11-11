import 'package:dio/dio.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/fund_cluster.dart';
import '../../../../../core/enums/purchase_request_status.dart';
import '../../../../../core/enums/unit.dart';
import '../../../../../core/error/dio_exception_formatter.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/http_service.dart';
import '../../models/paginated_purchase_request_result.dart';
import '../../models/purchase_request.dart';
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
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
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
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PurchaseRequestModel> getPurchaseRequestById({required String prId,}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'pr_id': prId,
      };

      final response = await httpService.get(
        endpoint: purchaseRequestIdEP,
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        return PurchaseRequestModel.fromJson(response.data);
      } else {
        throw const ServerException('Failed to fetch purchase request by id.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
