import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core Services
import 'core/features/issuance/data/data_sources/remote/issuance_remote_data_source.dart';
import 'core/features/issuance/data/data_sources/remote/issuance_remote_data_source_impl.dart';
import 'core/features/issuance/data/repository/issuance_repository_impl.dart';
import 'core/features/issuance/domain/repository/issuance_repository.dart';
import 'core/features/issuance/domain/usecases/get_issuance_by_id.dart';
import 'core/features/issuance/presentation/bloc/issuances_bloc.dart';
import 'core/features/purchase_request/data/data_sources/remote/purchase_request_remote_data_source.dart';
import 'core/features/purchase_request/data/data_sources/remote/purchase_request_remote_data_source_impl.dart';
import 'core/features/purchase_request/data/repository/purchase_request_repository_impl.dart';
import 'core/features/purchase_request/domain/repository/purchase_request_repository.dart';
import 'core/features/purchase_request/domain/usecases/get_paginated_purchase_requests.dart';
import 'core/features/purchase_request/domain/usecases/get_purchase_request_by_id.dart';
import 'core/features/purchase_request/presentation/bloc/bloc/purchase_requests_bloc.dart';
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

import 'features/notification/data/data_sources/remote/notification_remote_data_source.dart';
import 'features/notification/data/data_sources/remote/notification_remote_data_source_impl.dart';
import 'features/notification/data/repository/notification_repository_impl.dart';
import 'features/notification/domain/repository/notification_repository.dart';
import 'features/notification/domain/usecases/get_notifications.dart';
import 'features/notification/domain/usecases/read_notification.dart';
import 'features/notification/presentation/bloc/notifications_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  _registerCoreDependencies();
  _registerServicesDependencies();

  _registerAuthDependencies();
  _registerPurchaseRequestsDependencies();
  _registerIssuanceDependencies();
  _registerNotificationDependencies();
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

/// Purchase Request
void _registerPurchaseRequestsDependencies() {
  serviceLocator.registerFactory<PurchaseRequestRemoteDataSource>(
    () => PurchaseRequestRemoteDataSourceImpl(httpService: serviceLocator()),
  );

  serviceLocator.registerFactory<PurchaseRequestRepository>(
    () => PurchaseRequestRepositoryImpl(
        purchaseRequestRemoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory<GetPaginatedPurchaseRequests>(
    () => GetPaginatedPurchaseRequests(
        purchaseRequestRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<GetPurchaseRequestById>(
    () => GetPurchaseRequestById(purchaseRequestRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<PurchaseRequestsBloc>(
    () => PurchaseRequestsBloc(
      getPaginatedPurchaseRequests: serviceLocator(),
      getPurchaseRequestById: serviceLocator(),
    ),
  );
}

/// Issuance
void _registerIssuanceDependencies() {
  serviceLocator.registerFactory<IssuanceRemoteDataSource>(
    () => IssuanceRemoteDataSourceImpl(httpService: serviceLocator()),
  );

  serviceLocator.registerFactory<IssuanceRepository>(
    () => IssuanceRepositoryImpl(issuanceRemoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory<GetIssuanceById>(
    () => GetIssuanceById(issuanceRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<IssuancesBloc>(
    () => IssuancesBloc(
      getIssuanceById: serviceLocator(),
    ),
  );
}

/// Notification
void _registerNotificationDependencies() {
  serviceLocator.registerFactory<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(httpService: serviceLocator()),
  );

  serviceLocator.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(
        notificationRemoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory<GetNotifications>(
    () => GetNotifications(notificationRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<ReadNotification>(
        () => ReadNotification(notificationRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      getNotifications: serviceLocator(),
      readNotification: serviceLocator(),
    ),
  );
}
