
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkCheck {
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivity =
        await (Connectivity().checkConnectivity());

    if (connectivity.contains(ConnectivityResult.mobile)) {
      return await InternetConnectionChecker.instance.hasConnection ? true : false;
    } else if (connectivity.contains(ConnectivityResult.wifi)) {
      return await InternetConnectionChecker.instance.hasConnection ? true : false;
    } else {
      return false;
    }
  }
}
