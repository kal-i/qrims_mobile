part of 'issuances_bloc.dart';

sealed class IssuancesState extends Equatable {
  const IssuancesState();

  @override
  List<Object?> get props => [];
}

final class IssuancesInitial extends IssuancesState {}

final class IssuancesLoading extends IssuancesState {}

final class IssuanceLoaded extends IssuancesState {
  const IssuanceLoaded({
    required this.issuance,
  });

  final IssuanceEntity issuance;

  @override
  List<Object?> get props => [
        issuance,
      ];
}

final class IssuancesError extends IssuancesState {
  const IssuancesError({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];
}
