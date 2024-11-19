class RoutingConstants {
  static const loginViewRouteName = 'loginView';
  static const loginViewRoutePath = '/';

  static const registerViewRouteName = 'registerView';
  static const registerViewRoutePath = '/register';

  static const unAuthorizedViewRouteName = 'unauthorizedView';
  static const unAuthorizedViewRoutePath = '/unauthorized';

  static const changeEmailViewRouteName = 'changeEmailView';
  static const changeEmailViewRoutePath = '/changeEmail';

  static const otpVerificationViewRouteName = 'otpVerificationView';
  static const otpVerificationViewRoutePath = '/otpVerification';

  static const setUpNewPasswordViewRouteName = 'setNewPasswordView';
  static const setUpNewPasswordViewRoutePath = '/setNewPassword';

  static const homeViewRouteName = 'homeView';
  static const homeViewRoutePath = '/home';

  static const notificationViewRouteName = 'notificationView';
  static const notificationViewRoutePath = '/notification';

  static const qrScannerViewRouteName = 'qrScannerView';
  static const qrScannerViewRoutePath = '/qrScanner';

  static const historyViewRouteName = 'historyView';
  static const historyViewRoutePath = '/history';

  static const profileViewRouteName = 'profileView';
  static const profileViewRoutePath = '/profile';

  static const viewPurchaseRequestRouteName = 'viewPurchaseRequest';
  static const viewPurchaseRequestRoutePath = 'viewPurchaseRequest';
  static const viewPurchaseRequestFromHomeRouteName = 'viewPurchaseRequestFromHome';
  static const viewPurchaseRequestFromNotificationRouteName = 'viewPurchaseRequestFromNotification';
  static const viewPurchaseRequestFromQRScannerRouteName = 'viewPurchaseRequestFromQRScanner';
  static const viewPurchaseRequestFromHistoryRouteName = 'viewPurchaseRequestFromHistory';
  static const nestedHomePurchaseRequestViewRoutePath = '$homeViewRoutePath/$viewPurchaseRequestRoutePath';
  static const nestedNotificationPurchaseRequestViewRoutePath = '$notificationViewRoutePath/$viewPurchaseRequestRoutePath';
  static const nestedHistoryPurchaseRequestViewRoutePath = '$historyViewRoutePath/$viewPurchaseRequestRoutePath';

  static const viewIssuanceRouteName = 'viewIssuance';
  static const viewIssuanceRoutePath = 'viewIssuance';
  static const viewIssuanceFromHomeRouteName = 'viewIssuanceFromHome';
  static const viewIssuanceFromNotificationRouteName = 'viewIssuanceFromNotification';
  static const viewIssuanceFromQRScannerRouteName = 'viewIssuanceFromQRScanner';
  static const viewIssuanceFromHistoryRouteName = 'viewIssuanceFromHistory';
  static const nestedHomeIssuanceViewRoutePath = '$homeViewRoutePath/$viewIssuanceRoutePath';
  static const nestedNotificationIssuanceViewRoutePath = '$notificationViewRoutePath/$viewIssuanceRoutePath';
  static const nestedQRScannerIssuanceViewRoutePath = '$qrScannerViewRoutePath/$viewIssuanceRoutePath';
  static const nestedHistoryIssuanceViewRoutePath = '$historyViewRoutePath/$viewIssuanceRoutePath';

  static const viewItemRouteName = 'viewItem';
  static const viewItemRoutePath = 'item';
  static const nestedQRScannerItemViewRoutePath = '$qrScannerViewRoutePath/$viewItemRoutePath';

  static const settingsViewRouteName = 'settingsView';
  static const settingsViewRoutePath = 'settings';
  static const nestedSettingsViewRoutePath = '$profileViewRoutePath/$settingsViewRoutePath';
}
