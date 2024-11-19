import '../../../../error/failure.dart';
import 'package:fpdart/src/either.dart';

import '../../../../usecases/usecase.dart';
import '../repository/purchase_request_repository.dart';

class FollowUpPurchaseRequest implements UseCase<String, String> {
  const FollowUpPurchaseRequest({
    required this.purchaseRequestRepository,
  });

  final PurchaseRequestRepository purchaseRequestRepository;

  @override
  Future<Either<Failure, String>> call(String param) async {
    return await purchaseRequestRepository.followUpPurchaseRequest(
      prId: param,
    );
  }
}
