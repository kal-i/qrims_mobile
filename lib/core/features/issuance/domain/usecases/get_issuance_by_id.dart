import 'package:fpdart/src/either.dart';

import '../../../../entities/issuance/issuance.dart';
import '../../../../error/failure.dart';
import '../../../../usecases/usecase.dart';
import '../repository/issuance_repository.dart';

class GetIssuanceById implements UseCase<IssuanceEntity?, String> {
  const GetIssuanceById({
    required this.issuanceRepository,
  });

  final IssuanceRepository issuanceRepository;

  @override
  Future<Either<Failure, IssuanceEntity?>> call(String param) async {
    return await issuanceRepository.getIssuanceById(
      id: param,
    );
  }
}
