import 'package:fpdart/src/either.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/entities/item_inventory/item_with_stock.dart';
import '../../../../core/error/failure.dart';
import '../repository/item_repository.dart';

class GetItemByEncryptedId implements UseCase<ItemWithStockEntity?, String> {
  const GetItemByEncryptedId({
    required this.itemRepository,
  });

  final ItemRepository itemRepository;

  @override
  Future<Either<Failure, ItemWithStockEntity?>> call(String param) async {
    return await itemRepository.getItemByEncryptedId(
      id: param,
    );
  }
}
