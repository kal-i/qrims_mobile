import 'package:dio/dio.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../error/dio_exception_formatter.dart';
import '../../../../../error/exceptions.dart';
import '../../../../../models/issuance/issuance.dart';
import '../../../../../services/http_service.dart';
import 'issuance_remote_data_source.dart';

class IssuanceRemoteDataSourceImpl implements IssuanceRemoteDataSource {
  const IssuanceRemoteDataSourceImpl({
    required this.httpService,
  });

  final HttpService httpService;

  @override
  Future<IssuanceModel?> getIssuanceById({
    required String id,
  }) async {
    try {
      final response = await httpService.get(
        endpoint: '$issuancesIdEP/$id',
      );

      print('irds impl: $response');
      if (response.statusCode == 200) {
        return IssuanceModel.fromJson(response.data['issuance']);
      } else {
        throw const ServerException('Failed to load issuance.');
      }
    } on DioException catch (e) {
      final formattedError = formatDioError(e);
      throw ServerException(formattedError);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<IssuanceModel?> receiveIssuance({
    required String id,
  }) async {
    try {
      final response = await httpService.patch(
        endpoint: '$issuancesIdEP/$id',
      );

      // Handle successful follow-up
      if (response.statusCode == 200) {
        return IssuanceModel.fromJson(response.data['issuance']);
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
        final errorData = response.data as Map<String, dynamic>;
        throw ServerException(errorData['error'] ?? 'Not found.');
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
