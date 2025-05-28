import 'package:friendly_partner/app/screens/auth/signin_dashboard.dart';
import 'package:friendly_partner/app/screens/auth/signin_screen.dart';
import 'package:friendly_partner/app/screens/auth/signup_screen.dart';
import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/screens/home/home_screen.dart';
import 'package:friendly_partner/app/screens/partners/connected_wholeseller_screen.dart';
import 'package:friendly_partner/app/whole_seller/dashboard/whole_seller_dashboard.dart';
import 'package:get/get.dart';

import '../app/screens/auth/signup_dashboard.dart';
import '../app/screens/onboarding/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String signing = '/signing';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String connectedWholeSeller = '/connected-whole-seller';
  static const String wholeSellerDashboard = '/wholeseller-dashboard';
  /// Routes ==================>
  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getSigningRoute() => signing;
  static String getSignUpRoute() => signUp;
  static String getHomeRoute() => home;
  static String getDashboardRoute() => dashboard;
  static String getWholeSellerDashboardRoute() => wholeSellerDashboard;
  static String getConnectedWholeSellerRoute({
    bool ishideHeading = false,
    bool isHorizontalPaddinghide = false,
  }) =>
      '$connectedWholeSeller?ishideHeading=${ishideHeading.toString()}&isHorizontalPaddinghide';

  /// Pages ==================>

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    // GetPage(name: signing, page: () => SigningScreen()),
    GetPage(name: signing, page: () => SigningDashboard()),
    // GetPage(name: signUp, page: () => SignupScreen()),
    GetPage(name: signUp, page: () => SignupDashboard()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(
        name: connectedWholeSeller,
        page: () => ConnectedWholesellerScreen(
              ishideHeading: Get.parameters['ishideHeading'] == 'true',
              isHorizontalPaddinghide:
                  Get.parameters['isHorizontalPaddinghide'] == 'true',
            )),
    GetPage(name: wholeSellerDashboard, page: () => WholeSellerDashboard()),
  ];
}
