import '../../../../core/error/failure.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_request.dart';
import '../repository/purchase_request_repository.dart';

class GetPurchaseRequestById implements UseCase<PurchaseRequestEntity, String> {
  const GetPurchaseRequestById({
    required this.purchaseRequestRepository,
  });

  final PurchaseRequestRepository purchaseRequestRepository;

  @override
  Future<Either<Failure, PurchaseRequestEntity>> call(String param) async {
    return await purchaseRequestRepository.getPurchaseRequestById(
      prId: param,
    );
  }
}
