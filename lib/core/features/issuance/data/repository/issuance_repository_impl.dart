import 'package:fpdart/src/either.dart';

import '../../../../entities/issuance/issuance.dart';
import '../../../../error/exceptions.dart';
import '../../../../error/failure.dart';
import '../../domain/repository/issuance_repository.dart';
import '../data_sources/remote/issuance_remote_data_source.dart';

class IssuanceRepositoryImpl implements IssuanceRepository {
  const IssuanceRepositoryImpl({
    required this.issuanceRemoteDataSource,
  });

  final IssuanceRemoteDataSource issuanceRemoteDataSource;

  @override
  Future<Either<Failure, IssuanceEntity?>> getIssuanceById({
    required String id,
  }) async {
    try {
      final response = await issuanceRemoteDataSource.getIssuanceById(
        id: id,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, IssuanceEntity?>> receiveIssuance({
    required String id,
  }) async {
    try {
      final response = await issuanceRemoteDataSource.receiveIssuance(
        id: id,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
