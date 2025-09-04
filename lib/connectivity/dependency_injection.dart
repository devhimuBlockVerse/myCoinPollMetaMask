import 'package:get/get.dart';
import 'package:mycoinpoll_metamask/connectivity/connectivity_controller.dart';


class DependencyInjection{
  static void init(){
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}