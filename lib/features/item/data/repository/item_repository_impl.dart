import 'package:fpdart/src/either.dart';

import '../../../../core/entities/item_inventory/item_with_stock.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repository/item_repository.dart';
import '../data_sources/remote/item_remote_data_source.dart';

class ItemRepositoryImpl implements ItemRepository {
  const ItemRepositoryImpl({
    required this.itemRemoteDataSource,
  });

  final ItemRemoteDataSource itemRemoteDataSource;

  @override
  Future<Either<Failure, ItemWithStockEntity?>> getItemByEncryptedId({
    required String id,
  }) async {
    try {
      final response = await itemRemoteDataSource.getItemByEncryptedId(
        id: id,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
