part of 'item_bloc.dart';

sealed class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

final class ItemInitial extends ItemState {}

final class ItemLoading extends ItemState {}

final class ItemLoaded extends ItemState {
  const ItemLoaded({
    required this.item,
  });

  final ItemWithStockEntity item;
}

final class ItemNotFound extends ItemState {}

final class ItemError extends ItemState {
  const ItemError({
    required this.message,
  });

  final String message;
}
