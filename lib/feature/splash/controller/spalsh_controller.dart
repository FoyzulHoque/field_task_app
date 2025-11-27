import 'package:get/get.dart';

class SpalshController extends GetxController {
  void checkIsLogin() async {
    // Introduce a slight delay to ensure data is ready
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
