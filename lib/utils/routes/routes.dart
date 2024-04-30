import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/tabs/tabs.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/upload%20Invoice/add_invoice_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/upload%20Invoice/save_invoice.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/upload%20Invoice/upload_invoice_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/add_checklist_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/history_detail_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/replace_manually_screen.dart';
import 'package:shopease_app_flutter/ui/screens/notification/notification_screen.dart';
import 'package:shopease_app_flutter/ui/screens/profile/profile_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/checklist_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/select_shop_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/congratilations_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/mobile_login_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/nick_name_screen.dart';
import 'package:shopease_app_flutter/ui/screens/auth/otp_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/fetch_product_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/home_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory/add_inventroy_screen.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory/multiple_add_to_check_list.dart';
import 'package:shopease_app_flutter/ui/screens/home/product_detail_screen.dart';
import 'package:shopease_app_flutter/ui/screens/scan/scan_and_add_screen.dart';
import 'package:shopease_app_flutter/ui/screens/scan/scan_not_found_screen.dart';
import 'package:shopease_app_flutter/ui/screens/scan/scan_screen.dart';
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
  productDetail,
  fetchProduct,
  scanNotFoundScreen,
  multipleSelectProduct,

  ////////// BRANCH 2 //////////
  checkList,
  selectShop,
  addChecklistForm,
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
          final extra = state.extra as Map<String, dynamic>;
          return MobileLoginscreen(
            isEdit: extra['isEdit'],
            nickName: extra['nickName'],
          );
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
      GoRoute(
        path: AppRoute.scanAndAddScreen.path,
        name: AppRoute.scanAndAddScreen.name,
        builder: (context, state) {
          final extra =
              (state.extra ?? <String, dynamic>{}) as Map<String, dynamic>;
          return ScanAndAddScreen(
            isInvoice: extra['isInvoice'] ?? false,
            isReplace: extra['isReplace'] ?? false,
            isFromChecklist: extra['isFromChecklist'] ?? false,
          );
        },
      ),
      GoRoute(
        path: AppRoute.scanScreen.path,
        name: AppRoute.scanScreen.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ScanScreen(
            isInvoice: extra['isInvoice'] ?? false,
            isReplace: extra['isReplace'] ?? false,
            isFromChecklist: extra['isFromChecklist'] ?? false,
          );
        },
      ),
      GoRoute(
        path: AppRoute.scanNotFoundScreen.path,
        name: AppRoute.scanNotFoundScreen.name,
        builder: (BuildContext context, GoRouterState state) =>
            const ScanNotFoundScreen(),
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
                    path: AppRoute.addinventoryForm.name,
                    name: AppRoute.addinventoryForm.name,
                    builder: (context, state) {
                      final extra =
                          (state.extra ?? {}) as Map<dynamic, dynamic>;
                      return AddInventoryScreen(
                        isEdit: (extra['isEdit'] ?? false) as bool,
                        product: extra['details'],
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoute.productDetail.name,
                    name: AppRoute.productDetail.name,
                    builder: (context, state) => ProductDetailScreen(
                      product: state.extra as Product,
                    ),
                  ),
                  GoRoute(
                    path: AppRoute.fetchProduct.name,
                    name: AppRoute.fetchProduct.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const FetchProductScreen(),
                  ),
                  GoRoute(
                    path: AppRoute.multipleSelectProduct.name,
                    name: AppRoute.multipleSelectProduct.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const MultipleSelectionScreen(),
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
                    path: AppRoute.addChecklistForm.name,
                    name: AppRoute.addChecklistForm.name,
                    builder: (BuildContext context, GoRouterState state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return AddChecklistScreen(
                        isEdit: extra['isEdit'] ?? false,
                        product: extra['details'],
                      );
                    },
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
                    builder: (context, state) {
                      return HistoryDetailScreen(
                        invoice: state.extra as History,
                      );
                    },
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
