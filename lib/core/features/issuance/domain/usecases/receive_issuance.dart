import '../../../../entities/issuance/issuance.dart';
import '../../../../error/failure.dart';
import 'package:fpdart/src/either.dart';

import '../../../../usecases/usecase.dart';
import '../repository/issuance_repository.dart';

class ReceiveIssuance implements UseCase<IssuanceEntity?, String> {
  const ReceiveIssuance({
    required this.issuanceRepository,
  });

  final IssuanceRepository issuanceRepository;

  @override
  Future<Either<Failure,  IssuanceEntity?>> call(String param) async {
    return await issuanceRepository.receiveIssuance(
      id: param,
    );
  }
}
