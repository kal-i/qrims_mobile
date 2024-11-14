import 'package:fpdart/src/either.dart';

import '../../../../entities/purchase_request/purchase_request_with_notification_trail.dart';
import '../../../../error/failure.dart';
import '../../../../usecases/usecase.dart';
import '../repository/purchase_request_repository.dart';

class GetPurchaseRequestById implements UseCase<PurchaseRequestWithNotificationTrailEntity, String> {
  const GetPurchaseRequestById({
    required this.purchaseRequestRepository,
  });

  final PurchaseRequestRepository purchaseRequestRepository;

  @override
  Future<Either<Failure, PurchaseRequestWithNotificationTrailEntity>> call(String param) async {
    return await purchaseRequestRepository.getPurchaseRequestById(
      prId: param,
    );
  }
}
