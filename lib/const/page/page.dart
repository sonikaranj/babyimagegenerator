import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/pages/BIG_Splash_page.dart';
import 'package:get/get.dart';


class AppRoutes {
  static const SPLASH = '/splash';
  static const HOME = '/Home';

}

class AppPages {
  static final pages = [
    GetPage(
        name: AppRoutes.SPLASH,
        page: () => BIG_SplashPage(),
    ),
    GetPage(
        name: AppRoutes.HOME,
        page: () => BIG_Homepage(),
    ),
  ];
}
