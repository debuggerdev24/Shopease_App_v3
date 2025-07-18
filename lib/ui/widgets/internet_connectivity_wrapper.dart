import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/connectivity_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/no_connection_widget.dart';

class InternetConnectivityWrapper extends StatefulWidget {
  const InternetConnectivityWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<InternetConnectivityWrapper> createState() =>
      _InternetConnectivityWrapperState();
}

class _InternetConnectivityWrapperState
    extends State<InternetConnectivityWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (_, provider, __) {
      log("connection status ${provider.isConnected}");
      if (provider.isConnected) {
        return widget.child;
      } else {
        return const NoConnectionWidget();
      }
    });
  }
}
