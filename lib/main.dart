import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/connectivity_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/providers/receipt_scan_provider.dart';
import 'package:shopease_app_flutter/providers/scan_provider.dart';
import 'package:shopease_app_flutter/providers/theme_provider.dart';
import 'package:shopease_app_flutter/services/auth_service.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/services/checklist_service.dart';
import 'package:shopease_app_flutter/services/history_service.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/services/notifications_service.dart';
import 'package:shopease_app_flutter/services/profile_service.dart';
import 'package:shopease_app_flutter/services/scan_service.dart';
import 'package:shopease_app_flutter/utils/app_themes.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

late PackageInfo packageInfo;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeCoreApp();
  await SharedPrefs().init();
  await BaseRepository().intialize();
  if (SharedPrefs().idToken != null) {
    BaseRepository().addToken(SharedPrefs().idToken!);
  }
  runApp(const MyApp());
}

_initializeCoreApp() async {
  packageInfo = await PackageInfo.fromPlatform();
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
          create: (_) => ChecklistProvider(ChecklistService()),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(ProfileService()),
        ),
        ChangeNotifierProvider<HistoryProvider>(
          create: (_) => HistoryProvider(Historyservice()),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(NotificationsService()),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider<ReceiptScanProvider>(
          create: (_) => ReceiptScanProvider(),
        )
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
            title: 'Shopease App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            routerConfig: AppNavigator.router,
            debugShowCheckedModeBanner: false,
            themeMode: provider.currentThemeMode,
          );
        }),
      );
}

//new
//send exp. -> 2,10,
//need to more explanation -> 2,7,9
//fixed -> 5,3,6,11
//Worked on added the dependencies for the push notification.
//lutter cklWorked on
