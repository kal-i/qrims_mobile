import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/verification_purpose.dart';
import '../../core/features/issuance/presentation/views/view_issuance.dart';
import '../../core/features/purchase_request/presentation/views/view_purchase_request.dart';
import '../../features/auth/presentation/views/base_auth_view.dart';
import '../../features/auth/presentation/views/change_email_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/otp_verification_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/set_new_password_view.dart';
import '../../features/auth/presentation/views/unauthorized_view.dart';
import '../../features/history/presentation/views/history_view.dart';
import '../../features/item/presentation/views/item_view.dart';
import '../../features/notification/presentation/views/notifications_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/qr_scanner/presentation/views/qr_scanner_view.dart';
import '../../features/settings/presentation/views/settings_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/navigation/presentation/views/base_navigation.dart';
import 'app_routing_constants.dart';

class AppRoutingConfig {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _baseAuthShellNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: 'auth');
  static final _baseNavigationShellKey =
      GlobalKey<NavigatorState>(debugLabel: 'base nav');
  static final _prNavigationShellKey =
      GlobalKey<NavigatorState>(debugLabel: 'pr nav');

  static final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutingConstants.loginViewRoutePath,
    routes: [
      ShellRoute(
        navigatorKey: _baseAuthShellNavigationKey,
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: BaseAuthView(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            name: RoutingConstants.loginViewRouteName,
            path: RoutingConstants.loginViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: LoginView(),
            ),
          ),
          GoRoute(
            name: RoutingConstants.registerViewRouteName,
            path: RoutingConstants.registerViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: RegisterView(),
            ),
          ),
          GoRoute(
            name: RoutingConstants.unAuthorizedViewRouteName,
            path: RoutingConstants.unAuthorizedViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: UnauthorizedView(),
            ),
          ),
          GoRoute(
            name: RoutingConstants.changeEmailViewRouteName,
            path: RoutingConstants.changeEmailViewRoutePath,
            pageBuilder: (context, state) => MaterialPage(
              child: ChangeEmailView(
                purpose: state.extra as VerificationPurpose,
              ),
            ),
          ),
          GoRoute(
            name: RoutingConstants.otpVerificationViewRouteName,
            path: RoutingConstants.otpVerificationViewRoutePath,
            pageBuilder: (context, state) {
              final Map<String, dynamic> extras =
                  state.extra as Map<String, dynamic>;
              final email = extras['email'] as String;
              final purpose = extras['purpose'] as VerificationPurpose;

              return MaterialPage(
                child: OtpVerificationView(
                  email: email,
                  purpose: purpose,
                ),
              );
            },
          ),
          GoRoute(
            name: RoutingConstants.setUpNewPasswordViewRouteName,
            path: RoutingConstants.setUpNewPasswordViewRoutePath,
            pageBuilder: (context, state) => MaterialPage(
              child: SetNewPasswordView(
                email: state.extra as String,
              ),
            ),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _baseNavigationShellKey,
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: BaseNavigation(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            name: RoutingConstants.homeViewRouteName,
            path: RoutingConstants.homeViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: HomeView(),
            ),
            routes: [
              GoRoute(
                name: RoutingConstants.viewPurchaseRequestFromHomeRouteName,
                path: RoutingConstants.viewPurchaseRequestRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final prId = extras['pr_id'] as String;
                  final initLocation = extras['init_location'] as String;

                  return MaterialPage(
                    child: ViewPurchaseRequest(
                      prId: prId,
                      initLocation: initLocation,
                    ),
                  );
                },
              ),
              GoRoute(
                name: RoutingConstants.viewIssuanceFromHomeRouteName,
                path: RoutingConstants.viewIssuanceRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final issuanceId = extras['issuance_id'] as String;
                  print('received by route: $issuanceId');

                  return MaterialPage(
                    child: ViewIssuanceInformation(issuanceId: issuanceId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutingConstants.notificationViewRouteName,
            path: RoutingConstants.notificationViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: NotificationsView(),
            ),
            routes: [
              GoRoute(
                name: RoutingConstants
                    .viewPurchaseRequestFromNotificationRouteName,
                path: RoutingConstants.viewPurchaseRequestRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final prId = extras['pr_id'] as String;
                  final initLocation = extras['init_location'] as String;

                  return MaterialPage(
                    child: ViewPurchaseRequest(
                      prId: prId,
                      initLocation: initLocation,
                    ),
                  );
                },
              ),
              GoRoute(
                name: RoutingConstants.viewIssuanceFromNotificationRouteName,
                path: RoutingConstants.viewIssuanceRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final issuanceId = extras['issuance_id'] as String;
                  print('received by route: $issuanceId');

                  return MaterialPage(
                    child: ViewIssuanceInformation(issuanceId: issuanceId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutingConstants.qrScannerViewRouteName,
            path: RoutingConstants.qrScannerViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: QrScannerView(),
            ),
            routes: [
              GoRoute(
                name:
                    RoutingConstants.viewPurchaseRequestFromQRScannerRouteName,
                path: RoutingConstants.viewPurchaseRequestRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final prId = extras['pr_id'] as String;
                  final initLocation = extras['init_location'] as String;

                  return MaterialPage(
                    child: ViewPurchaseRequest(
                      prId: prId,
                      initLocation: initLocation,
                    ),
                  );
                },
              ),
              GoRoute(
                name: RoutingConstants.viewItemRouteName,
                path: RoutingConstants.viewItemRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final itemId = extras['item_id'] as String;
                  final decodedId = Uri.decodeComponent(itemId);
                  return MaterialPage(
                    child: ItemView(
                      itemId: decodedId,
                    ),
                  );
                },
              ),
              GoRoute(
                name: RoutingConstants.viewIssuanceFromQRScannerRouteName,
                path: RoutingConstants.viewIssuanceRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final issuanceId = extras['issuance_id'] as String;
                  print('received by route: $issuanceId');

                  return MaterialPage(
                    child: ViewIssuanceInformation(issuanceId: issuanceId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutingConstants.historyViewRouteName,
            path: RoutingConstants.historyViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: HistoryView(),
            ),
            routes: [
              GoRoute(
                name: RoutingConstants.viewPurchaseRequestFromHistoryRouteName,
                path: RoutingConstants.viewPurchaseRequestRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final prId = extras['pr_id'] as String;
                  final initLocation = extras['init_location'] as String;

                  return MaterialPage(
                    child: ViewPurchaseRequest(
                      prId: prId,
                      initLocation: initLocation,
                    ),
                  );
                },
              ),
              GoRoute(
                name: RoutingConstants.viewIssuanceFromHistoryRouteName,
                path: RoutingConstants.viewIssuanceRoutePath,
                pageBuilder: (context, state) {
                  final Map<String, dynamic> extras =
                      state.extra as Map<String, dynamic>;
                  final issuanceId = extras['issuance_id'] as String;
                  print('received by route: $issuanceId');

                  return MaterialPage(
                    child: ViewIssuanceInformation(issuanceId: issuanceId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutingConstants.profileViewRouteName,
            path: RoutingConstants.profileViewRoutePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: ProfileView(),
            ),

            // add a nested route within a shell route
            // ensure not to add the '/' at the beginning of path name
            routes: [
              GoRoute(
                name: RoutingConstants.settingsViewRouteName,
                path: RoutingConstants.settingsViewRoutePath,
                pageBuilder: (context, state) => const MaterialPage(
                  child: SettingsView(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// we'll use stateful shell route for navigation bar to wrap the main content
// and prevent the bottom nav bar from rebuilding each time we navigate to a next page
// StatefulShellRoute.indexedStack(
//   builder: (context, state, navigationShell) => BaseNavigation(
//     navigationShell: navigationShell,
//   ),
//   branches: [
//     StatefulShellBranch(
//       routes: [
//         GoRoute(
//           name: RoutingConstants.homeViewRouteName,
//           path: RoutingConstants.homeViewRoutePath,
//           builder: (context, state) => const HomeView(),
//         ),
//       ],
//     ),
//     StatefulShellBranch(
//       routes: [
//         GoRoute(
//           name: RoutingConstants.notificationViewRouteName,
//           path: RoutingConstants.notificationViewRoutePath,
//           builder: (context, state) => const NotificationsView(),
//         ),
//       ],
//     ),
//     StatefulShellBranch(
//       routes: [
//         GoRoute(
//           name: RoutingConstants.qrScannerViewRouteName,
//           path: RoutingConstants.qrScannerViewRoutePath,
//           builder: (context, state) => const QrScannerView(),
//         ),
//       ],
//     ),
//     StatefulShellBranch(
//       routes: [
//         GoRoute(
//           name: RoutingConstants.historyViewRouteName,
//           path: RoutingConstants.historyViewRoutePath,
//           builder: (context, state) => const HomeView(),
//         ),
//       ],
//     ),
//     StatefulShellBranch(
//       routes: [
//         GoRoute(
//           name: RoutingConstants.profileViewRouteName,
//           path: RoutingConstants.profileViewRoutePath,
//           builder: (context, state) => const ProfileView(),
//
//           // add a nested route within a shell route
//           // ensure not to add the '/' at the beginning of path name
//           routes: [
//             GoRoute(
//               name: RoutingConstants.settingsViewRouteName,
//               path: RoutingConstants.settingsViewRoutePath,
//               builder: (context, state) => const SettingsView(),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// ),
