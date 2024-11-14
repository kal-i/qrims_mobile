import '../../../../../models/issuance/issuance.dart';

abstract interface class IssuanceRemoteDataSource {
  Future<IssuanceModel?> getIssuanceById({
    required String id,
  });
}
