import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../screen/no_internet_screen.dart';

class NetworkController extends GetxService {
  final hasConnection = true.obs;

  StreamSubscription<dynamic>? _connSub;
  StreamSubscription<InternetStatus>? _netSub;

  Future<NetworkController> init() async {
    final connected = await InternetConnection().hasInternetAccess;
    hasConnection.value = connected;
    _routeAccordingTo(connected);

    _connSub = Connectivity().onConnectivityChanged.listen((_) async {
      final ok = await InternetConnection().hasInternetAccess;
      hasConnection.value = ok;
    });

    _netSub = InternetConnection().onStatusChange.listen((status) {
      final ok = status == InternetStatus.connected;
      if (hasConnection.value != ok) {
        hasConnection.value = ok;
      }
    });

    ever<bool>(hasConnection, (ok) => _routeAccordingTo(ok));
    return this;
  }

  void _routeAccordingTo(bool ok) {
    if (!ok) {
      if (Get.currentRoute != NoInternetScreen.route) {
        Get.to(
              () => const NoInternetScreen(),
          routeName: NoInternetScreen.route,
          preventDuplicates: true,
        );
      }
    } else {
      // 👇 net aate hi bina condition ke pop
      if (Get.currentRoute == NoInternetScreen.route) {
        // Back to the previous screen on the stack
        Get.back();
      }
    }
  }

  @override
  void onClose() {
    _connSub?.cancel();
    _netSub?.cancel();
    super.onClose();
  }
}
