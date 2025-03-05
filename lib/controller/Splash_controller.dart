
import 'package:babyimage/const/page/page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {

    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.HOME);
    });
    // TODO: implement onReady
    super.onReady();
  }

}