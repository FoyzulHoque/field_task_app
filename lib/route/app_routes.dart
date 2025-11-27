import 'package:field_task_app/feature/splash/view/splash_view.dart';
import 'package:get/get.dart';

class AppRoute {
  static String splashView = '/splashScreen';

  static String getSplashView() => splashView;

  static List<GetPage> routes = [
    GetPage(name: splashView, page: () => SplashView()),
  ];
}
