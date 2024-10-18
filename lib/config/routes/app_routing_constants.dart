class RoutingConstants {
  static const loginViewRouteName = 'loginView';
  static const loginViewRoutePath = '/';

  static const registerViewRouteName = 'registerView';
  static const registerViewRoutePath = '/register';

  static const changeEmailViewRouteName = 'changeEmailView';
  static const changeEmailViewRoutePath = '/changeEmail';

  static const otpVerificationViewRouteName = 'otpVerificationView';
  static const otpVerificationViewRoutePath = '/otpVerification';

  static const setUpNewPasswordViewRouteName = 'setNewPasswordView';
  static const setUpNewPasswordViewRoutePath = '/setNewPassword';

  static const homeViewRouteName = 'homeView';
  static const homeViewRoutePath = '/home';

  static const qrScannerViewRouteName = 'qrScannerView';
  static const qrScannerViewRoutePath = '/qrScanner';
  //static const nestedQrScannerViewRoutePath = '$homeViewRoutePath/$qrScannerViewRoutePath';

  static const notificationViewRouteName = 'notificationView';
  static const notificationViewRoutePath = '/notification';

  static const historyViewRouteName = 'historyView';
  static const historyViewRoutePath = '/history';

  static const profileViewRouteName = 'profileView';
  static const profileViewRoutePath = '/profile';

  static const settingsViewRouteName = 'settingsView';
  static const settingsViewRoutePath = 'settings';
  static const nestedSettingsViewRoutePath = '$profileViewRoutePath/$settingsViewRoutePath';
}
