import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
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
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await BaseRepository().intialize();
  if (SharedPrefs().idToken != null) {
    BaseRepository().addToken(SharedPrefs().idToken!);
  }
  await Constants.getCategories();
  runApp(const MyApp());
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
