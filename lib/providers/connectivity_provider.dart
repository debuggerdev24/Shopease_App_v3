import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  /// Constructor
  ConnectivityProvider() {
    getCurrentConnectivityStatus();
    addConnectivityListner();
  }

  /// Connectivity
  bool? _isConnected;

  bool get isConnected => _isConnected ?? false;

  addConnectivityListner() {
    Connectivity().onConnectivityChanged.listen((result) {
      log("connectivity status $result");
      _isConnected = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.ethernet) ||
          result.contains(ConnectivityResult.vpn);
      notifyListeners();
    });
  }

  getCurrentConnectivityStatus() async {
    notifyListeners();
    Connectivity().checkConnectivity().then((value) {
      log("value in getCurrentConnectivityStatus $value");
      _isConnected = value.contains(ConnectivityResult.wifi) ||
          value.contains(ConnectivityResult.mobile) ||
          value.contains(ConnectivityResult.ethernet) ||
          value.contains(ConnectivityResult.vpn);
      notifyListeners();
    });
  }
}
