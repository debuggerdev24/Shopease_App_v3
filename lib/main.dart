import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/providers/scan_provider.dart';
import 'package:shopease_app_flutter/providers/theme_provider.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/auth_service.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/services/scan_service.dart';
import 'package:shopease_app_flutter/utils/app_themes.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  await SharedPrefs().init();
  await BaseRepository().intialize();
  if(SharedPrefs().idToken != null) {
    BaseRepository().addToken(SharedPrefs().idToken!);
  }
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'callRefreshAuthAPI') {
      await SharedPrefs().init();
      log('new prefs initialized.');
      await BaseRepository().intialize();
      log('new dio initialized.');
      return await AuthProvider(AuthService()).refreshAuth(
        onSuccess: () => true,
        onError: (msg) => false,
      );

      // final dio = Dio(
      //   BaseOptions(
      //     baseUrl: ApiUrl.devBaseURL,
      //     headers: {'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0'},
      //   ),
      // );
      // dio.interceptors.add(
      //   PrettyDioLogger(request: true, requestBody: true, requestHeader: true),
      // );

      // final resp = await dio.post(
      //   ApiUrl.refreshAuth,
      //   data: inputData,
      // );

      // if (resp.statusCode == 200) {
      //   SharedPrefs().setAccessToken(resp.data['AccessToken']);
      //   SharedPrefs().setIdToken(resp.data['IdToken']);
      //   return true;
      // }
    }
    return false;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(AuthService()),
        ),
        ChangeNotifierProvider<ScannerProvider>(
          create: (_) => ScannerProvider(ScannerService()),
        ),
        ChangeNotifierProvider<InventoryProvider>(
          create: (_) => InventoryProvider(InventoryService()),
        ),
        ChangeNotifierProvider<ChecklistProvider>(
          create: (_) => ChecklistProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: buildMyapp(),
    );
  }

  Widget buildMyapp() => ScreenUtilInit(
        ensureScreenSize: true,
        designSize: const Size(390, 844),
        builder: (context, child) =>
            Consumer<ThemeProvider>(builder: (context, provider, _) {
          return MaterialApp.router(
            title: 'Your App Name',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            routerConfig: AppNavigator.router,
            debugShowCheckedModeBanner: false,
            themeMode: provider.currentThemeMode,
          );
        }),
      );
}
