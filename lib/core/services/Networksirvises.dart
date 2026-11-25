import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends GetxService {
  final isOnline = true.obs;
  StreamSubscription<InternetStatus>? _sub;

  Future<NetworkService> init() async {
    isOnline.value = await InternetConnection().hasInternetAccess;
    _sub = InternetConnection().onStatusChange.listen((status) {
      isOnline.value = status == InternetStatus.connected;
    });
    return this;
  }

  @override
  void onClose() {
    _sub?.cancel(); // مهم: لا تترك الـ stream مفتوحاً
    super.onClose();
  }
}