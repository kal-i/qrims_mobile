import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/models/item_inventory/item_with_stock.dart';
import '../../../../../core/services/http_service.dart';
import 'item_remote_data_source.dart';

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  const ItemRemoteDataSourceImpl({
    required this.httpService,
  });

  final HttpService httpService;

  @override
  Future<ItemWithStockModel?> getItemByEncryptedId({
    required String id,
  }) async {
    try {
      final response = await httpService.get(
        endpoint: '$itemsEncryptedIdEP/$id',
      );

      if (response.statusCode != 200) {
        throw ServerException(response.statusMessage.toString());
      }
      // todo: note: carefully check api res when encounter a bad state: no elem found
      return ItemWithStockModel.fromJson(response.data['item']);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? e.response?.statusMessage;

        if (e.response?.statusCode == HttpStatus.notFound &&
            errorMessage == 'Item not found.') {
          throw const ServerException('Item not found.');
        }
        throw ServerException(
          'DioException: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else {
        throw ServerException(
          'DioException: ${e.message}',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
