import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'resources.dart';

class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<bool> checkYandex() async {
    var check = false;

    try {
      final result = await InternetAddress.lookup(Strings.yandex);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        check = true;
      }
    } on SocketException catch (_) {
      check = false;
    }
    return check;
  }
}
