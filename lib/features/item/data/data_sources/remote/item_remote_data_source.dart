import '../../../../../core/models/item_inventory/item_with_stock.dart';

abstract interface class ItemRemoteDataSource {
  Future<ItemWithStockModel?> getItemByEncryptedId({
    required String id,
  });
}