import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core Services
import 'core/services/http_service.dart';

// Authentication
import 'core/services/org_suggestions_service.dart';
import 'features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/domain/usecases/user_logout.dart';
import 'features/auth/domain/usecases/user_register.dart';
import 'features/auth/domain/usecases/user_reset_password.dart';
import 'features/auth/domain/usecases/user_send_otp.dart';
import 'features/auth/domain/usecases/user_update_info.dart';
import 'features/auth/domain/usecases/user_verify_otp.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  _registerCoreDependencies();
  _registerServicesDependencies();

  _registerAuthDependencies();
}

/// Core Services
void _registerCoreDependencies() {
  serviceLocator.registerSingleton<Dio>(Dio());
  serviceLocator.registerSingleton<HttpService>(HttpService(serviceLocator()));
}

void _registerServicesDependencies() {
  serviceLocator.registerSingleton<OfficerSuggestionsService>(
      OfficerSuggestionsService(httpService: serviceLocator()));
}

/// Authentication
void _registerAuthDependencies() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(httpService: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory<UserRegister>(
        () => UserRegister(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserLogin>(
        () => UserLogin(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserSendOtp>(
        () => UserSendOtp(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserVerifyOtp>(
        () => UserVerifyOtp(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserResetPassword>(
        () => UserResetPassword(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserLogout>(
        () => UserLogout(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserUpdateInfo>(
        () => UserUpdateInfo(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthBloc>(
        () => AuthBloc(
      userRegister: serviceLocator(),
      userLogin: serviceLocator(),
      userSendOtp: serviceLocator(),
      userVerifyOtp: serviceLocator(),
      userResetPassword: serviceLocator(),
      userLogout: serviceLocator(),
      userUpdateInfo: serviceLocator(),
    ),
  );
}