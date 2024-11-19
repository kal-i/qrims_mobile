part of 'purchase_requests_bloc.dart';

sealed class PurchaseRequestsState extends Equatable {
  const PurchaseRequestsState();

  @override
  List<Object?> get props => [];
}

final class PurchaseRequestsInitial extends PurchaseRequestsState {}

final class PurchaseRequestsLoading extends PurchaseRequestsState {}

final class PurchaseRequestsLoaded extends PurchaseRequestsState {
  const PurchaseRequestsLoaded({
    required this.purchaseRequests,
    required this.totalPurchaseRequestsCount,
    required this.totalPendingPurchaseRequestsCount,
    required this.totalIncompletePurchaseRequestsCount,
    required this.totalCompletePurchaseRequestsCount,
    required this.totalCancelledPurchaseRequestsCount,
  });

  final List<PurchaseRequestEntity> purchaseRequests;
  final int totalPurchaseRequestsCount;
  final int totalPendingPurchaseRequestsCount;
  final int totalIncompletePurchaseRequestsCount;
  final int totalCompletePurchaseRequestsCount;
  final int totalCancelledPurchaseRequestsCount;

  @override
  List<Object?> get props => [
        purchaseRequests,
        totalPurchaseRequestsCount,
      ];
}

final class PurchaseRequestLoaded extends PurchaseRequestsState {
  const PurchaseRequestLoaded({
    required this.purchaseRequestWithNotificationTrailEntity,
  });

  final PurchaseRequestWithNotificationTrailEntity purchaseRequestWithNotificationTrailEntity;
}

final class PurchaseRequestFollowedUp extends PurchaseRequestsState {
  const PurchaseRequestFollowedUp({
    required this.message,
  });

  final String message;
}

final class PurchaseRequestFollowUpError extends PurchaseRequestsState {
  const PurchaseRequestFollowUpError({
    required this.message,
  });

  final String message;
}

final class PurchaseRequestsError extends PurchaseRequestsState {
  const PurchaseRequestsError({
    required this.message,
  });

  final String message;
}
