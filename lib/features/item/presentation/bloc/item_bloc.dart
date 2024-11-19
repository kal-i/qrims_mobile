import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/item_inventory/item_with_stock.dart';
import '../../domain/usecases/get_item_by_encrypted_id.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc({
    required GetItemByEncryptedId getItemByEncryptedId,
  })  : _getItemByEncryptedId = getItemByEncryptedId,
        super(ItemInitial()) {
    on<GetItemByEncryptedIdEvent>(_onGetItemByEncryptedId);
  }

  final GetItemByEncryptedId _getItemByEncryptedId;

  void _onGetItemByEncryptedId(
    GetItemByEncryptedIdEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(ItemLoading());

    final response = await _getItemByEncryptedId(
      event.id,
    );

    response.fold(
      (l) {
        if (l.message.contains('Item not found.')) {
          emit(ItemNotFound());
        } else {
          emit(ItemError(message: l.message));
        }
      },
      (r) => emit(
        ItemLoaded(
          item: r!,
        ),
      ),
    );
  }
}
