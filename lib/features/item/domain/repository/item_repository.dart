import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/item_inventory/item_with_stock.dart';
import '../../../../core/error/failure.dart';

abstract interface class ItemRepository {
  Future<Either<Failure, ItemWithStockEntity?>> getItemByEncryptedId({
    required String id,
  });
}