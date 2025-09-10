
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController{
  final Connectivity _connectivity = Connectivity();
  final RxBool isOfflineOverlayVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnectivity();
  }


  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {

      isOfflineOverlayVisible.value = true;

      Get.rawSnackbar(
        messageText: const Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 35,
        ),
        snackStyle: SnackStyle.GROUNDED,
        margin: EdgeInsets.zero,
      );
    } else {
      isOfflineOverlayVisible.value = false;

      if (Get.isSnackbarOpen!) Get.closeCurrentSnackbar();

      // // Show brief back online snackbar
      // Get.rawSnackbar(
      //   messageText: const Text(
      //     'Back Online!',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 14,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   duration: const Duration(seconds: 3),
      //   backgroundColor: Colors.green[400]!,
      //   icon: const Icon(
      //     Icons.wifi,
      //     color: Colors.white,
      //     size: 35,
      //   ),
      //   snackStyle: SnackStyle.GROUNDED,
      //   margin: EdgeInsets.zero,
      // );
    }
  }
}
