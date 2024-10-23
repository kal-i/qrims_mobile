import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user/user.dart';
import '../../../../core/enums/admin_approval_status.dart';
import '../../../../core/enums/auth_status.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/user/mobile_user.dart';
import '../../../../core/models/user/supply_department_employee.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

// UseCase<Type, Params>
class UserLogin implements UseCase<UserEntity, UserLoginParams> {
  const UserLogin({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UserLoginParams params) async {
    // return await authRepository.bearerLogin(
    //   email: params.email,
    //   password: params.password,
    // );
    final result = await authRepository.bearerLogin(
      email: params.email,
      password: params.password,
    );

    return result.fold(
      (l) => left(l),
      (r) {
        if (r is SupplyDepartmentEmployeeModel) {
          return left(const Failure('Unauthorized user.'));
        }

        if (r.isArchived) {
          return left(const Failure('User account is archived.'));
        }

        if (r.authStatus == AuthStatus.unauthenticated) {
          return left(const Failure('User is not authenticated.'));
        }

        if (r.authStatus == AuthStatus.revoked) {
          return left(const Failure('User access is denied.'));
        }

        if (r is MobileUserModel) {
          if (r.adminApprovalStatus == AdminApprovalStatus.pending) {
            return left(const Failure('Your account is awaiting admin approval. Please check back later or contact support for further assistance.'));
          }

          if (r.adminApprovalStatus == AdminApprovalStatus.rejected) {
            return left(const Failure('Your account has been rejected by the admin. Please contact support if you believe this is a mistake.'));
          }
        }

        return right(r);
      },
    );
  }
}

class UserLoginParams {
  const UserLoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
