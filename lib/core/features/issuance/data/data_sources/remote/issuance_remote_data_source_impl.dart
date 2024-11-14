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
}
