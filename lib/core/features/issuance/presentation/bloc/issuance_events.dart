part of 'issuances_bloc.dart';

sealed class IssuancesEvent extends Equatable {
  const IssuancesEvent();

  @override
  List<Object?> get props => [];
}

final class GetIssuanceByIdEvent extends IssuancesEvent {
  const GetIssuanceByIdEvent({
    required this.id,
  });

  final String id;
}

final class ReceiveIssuanceEvent extends IssuancesEvent {
  const ReceiveIssuanceEvent({
    required this.id,
  });

  final String id;
}
