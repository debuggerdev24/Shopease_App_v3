import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/tabs/tabs.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/Upload%20Invoice/add_invoice_screen.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/Upload%20Invoice/save_invoice.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/Upload%20Invoice/upload_invoice_screen.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/history_detail_screen.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/replace_manually_screen.dart';
import 'package:shopease_app_flutter/ui/screens/Notification/notificationScreen.dart';
import 'package:shopease_app_flutter/ui/screens/Profile/myprofile.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/checklist_screen.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/select_shop_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/congratilations_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/mobile_login_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/nick_name_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/otp_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/home_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory/view_inventory_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory/add_inventroy_form.dart';
import 'package:shopease_app_flutter/ui/screens/home/product_detail_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/scan_and_addscreen.dart';
import 'package:shopease_app_flutter/ui/screens/home/scan_screen.dart';
import 'package:shopease_app_flutter/ui/screens/on_boarding/on_board_screen.dart';
import 'package:shopease_app_flutter/ui/screens/splash/splash_screen.dart';

enum AppRoute {
  splashScreen,
  onBoardScreen,
  mobileLoginScreen,
  otpScreen,
  nickNameScreen,
  congratulationsScreen,

  ////////// BRANCH 1 //////////
  home,
  scanAndAddScreen,
  scanScreen,
  addinventoryForm,
  viewInventory,
  productDetail,

  ////////// BRANCH 2 //////////
  checkList,
  selectShop,
  replaceManually,
  uploadInvoice,
  addInvoice,
  saveInvoice,
  historyDetail,

  ////////// BRANCH 3 //////////
  profile,

  ////////// BRANCH 4 //////////
  notifications,
}

extension PathName on AppRoute {
  String get path => switch (this) { AppRoute.home => "/", _ => "/$name" };
}

class AppNavigator {
  AppNavigator._();

  static final _rootNavigator =
      GlobalKey<NavigatorState>(debugLabel: "ROOT NAVIGATOR");

  static GlobalKey<NavigatorState> get rootNavigator => _rootNavigator;

  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: "INVENTORY NAVIGATOR");
  static final _shellNavigatorChecklist =
      GlobalKey<NavigatorState>(debugLabel: "CHECKLIST NAVIGATOR");

  static final _shellNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: "PROFILE NAVIGATOR");

  static final _shellNavigatorNotification =
      GlobalKey<NavigatorState>(debugLabel: "NOTIFICATION NAVIGATOR");
  static StatefulNavigationShell? indexedStackNavigationShell;

  static final router = GoRouter(
    initialLocation: AppRoute.splashScreen.path,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigator,
    routes: [
      GoRoute(
        path: AppRoute.splashScreen.path,
        name: AppRoute.splashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.onBoardScreen.path,
        name: AppRoute.onBoardScreen.name,
        builder: (context, state) => const OnBoardScreen(),
      ),
      GoRoute(
        path: AppRoute.mobileLoginScreen.path,
        name: AppRoute.mobileLoginScreen.name,
        builder: (context, state) {
          final extra = state.extra as bool;
          return MobileLoginscreen(isEdit: extra);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigator,
        path: AppRoute.otpScreen.path,
        name: AppRoute.otpScreen.name,
      


         builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return OtpScreen(
                        isEdit: extra['isEdit'] as bool,
                        mobile: extra['mobile'] as String,
                      );
                    },
      ),
      GoRoute(
        path: AppRoute.nickNameScreen.path,
        name: AppRoute.nickNameScreen.name,
        builder: (context, state) => NickNameScreen(),
      ),
      GoRoute(
        path: AppRoute.congratulationsScreen.path,
        name: AppRoute.congratulationsScreen.name,
        builder: (context, state) => const CongaratulationsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          indexedStackNavigationShell = navigationShell;
          return TabScreen(
            key: state.pageKey,
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: AppRoute.scanAndAddScreen.name,
                    name: AppRoute.scanAndAddScreen.name,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return ScanAndAddScreen(
                        isInvoice: extra['isInvoice'] as bool,
                        isReplace: extra['isReplace'] as bool,
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.scanScreen.name,
                    name: AppRoute.scanScreen.name,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return ScanScreen(
                        isInvoice: extra['isInvoice'] as bool,
                        isReplace: extra['isReplace'] as bool,
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.viewInventory.name,
                    name: AppRoute.viewInventory.name,
                    builder: (context, state) => const ViewInventoryScreen(),
                  ),
                  GoRoute(
                    path: AppRoute.addinventoryForm.name,
                    name: AppRoute.addinventoryForm.name,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return Addinventory(
                        isEdit: extra['isEdit'] as bool,
                        details: extra['details'] ?? {},
                        isReplace: extra['isReplace'] as bool,
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.productDetail.name,
                    name: AppRoute.productDetail.name,
                    builder: (context, state) => ProductDetailScreen(
                      product: state.extra as Map<String, dynamic>,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChecklist,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.checkList.path,
                name: AppRoute.checkList.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const ChecklistScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: AppRoute.selectShop.name,
                    name: AppRoute.selectShop.name,
                    builder: (context, state) => const SelectShopScreen(),
                  ),
                  GoRoute(
                    path: AppRoute.replaceManually.name,
                    name: AppRoute.replaceManually.name,
                    builder: (context, state) => const ReplaceManuallyscvreen(),
                  ),
                  GoRoute(
                    path: AppRoute.uploadInvoice.name,
                    name: AppRoute.uploadInvoice.name,
                    builder: (context, state) => const UploadInvoiceScreen(),
                  ),
                  GoRoute(
                    path: AppRoute.addInvoice.name,
                    name: AppRoute.addInvoice.name,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return AddInvoiceScreen(
                        shop: extra['shop'] as String,
                        total: extra['total'] as int,
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.saveInvoice.name,
                    name: AppRoute.saveInvoice.name,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return SaveInvoiceScreen(
                        shop: extra['shop'] as String,
                        total: extra['total'] as int,
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.historyDetail.name,
                    name: AppRoute.historyDetail.name,
                    builder: (context, state) => HistoryDetailScreen(
                      invoice: state.extra as Map<String, dynamic>,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
                routes: const <RouteBase>[],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorNotification,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.notifications.path,
                name: AppRoute.notifications.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const NotificationScreen(),
                routes: const <RouteBase>[],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
