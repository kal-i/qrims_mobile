part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

final class GetItemByEncryptedIdEvent extends ItemEvent {
  const GetItemByEncryptedIdEvent({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [
        id,
      ];
}
