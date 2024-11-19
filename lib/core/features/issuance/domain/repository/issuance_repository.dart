import 'package:fpdart/fpdart.dart';

import '../../../../error/failure.dart';
import '../../../../entities/issuance/issuance.dart';

abstract interface class IssuanceRepository {
  Future<Either<Failure, IssuanceEntity?>> getIssuanceById({
    required String id,
  });

  Future<Either<Failure, IssuanceEntity?>> receiveIssuance({
    required String id,
  });
}
