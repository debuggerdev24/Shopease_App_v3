import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/screens/app_tour/app_tour.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() {
    return TabScreenState();
  }
}

class TabScreenState extends State<TabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChecklistProvider>().getChecklistItems();
    context.read<NotificationProvider>().getNotifications();
    context.read<NotificationProvider>().getinvitations();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Utils.getCategories();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goToBranch(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Expanded(child: widget.navigationShell),
          bottomNavigationBar(),
        ],
      ),
      // bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return KBottomNavBar(
      currentIndex: widget.navigationShell.currentIndex,
      onTap: (index) {
        if (index == 0) {
          context.read<InventoryProvider>().getInventoryItems();
        }

        if (index == 1) {
          context.read<ChecklistProvider>().selectedChecklists.clear();
          context.read<ChecklistProvider>().getChecklistItems();
          context.read<HistoryProvider>().getHistoryItems();
        }

        if (index == 2) {
          context.read<ProfileProvider>().getProfile(
            onSuccess: () {
              context.read<ProfileProvider>().getAllProfile();
            },
          );
        }

        // Saroj wants to call this APIs on every tab click.
        context.read<NotificationProvider>().getNotifications();
        context.read<NotificationProvider>().getinvitations();

        goToBranch(index);
      },
      items: [
        KBottomNavItem(
          key: invTabButtonKey,
          svgIcon: AppAssets.menu,
          isSelected: widget.navigationShell.currentIndex == 0,
        ),
        Consumer<ChecklistProvider>(builder: (context, provider, _) {
          return KBottomNavItem(
            key: checkListTabButtonKey,
            svgIcon: AppAssets.addtocart,
            isSelected: widget.navigationShell.currentIndex == 1,
            counterWidget: CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.redColor,
              child: GlobalText(
                provider.checklist.length.toString(),
                textStyle: textStyle12.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
        KBottomNavItem(
          key: profileTabButtonKey,
          isSelected: widget.navigationShell.currentIndex == 2,
          svgIcon: AppAssets.person,
        ),
        Consumer<NotificationProvider>(builder: (context, provider, _) {
          log('invites => ${provider.invitations}');
          log('any with unread => ${provider.invitations.any((e) => !e.isMessageRead)}');
          return KBottomNavItem(
            isSelected: widget.navigationShell.currentIndex == 3,
            svgIcon: AppAssets.notification,
            counterWidget: provider.notifications
                        .any((element) => !element.isMessageRead) ||
                    provider.invitations.any((e) => !e.isMessageRead)
                ? Container(
                    height: 18.h,
                    width: 19.h,
                    alignment: Alignment.bottomLeft,
                    child: CircleAvatar(
                      radius: 5.r,
                      backgroundColor: AppColors.redColor,
                    ),
                  )
                : null,
          );
        })
      ],
    );
  }
}

class KBottomNavBar extends StatefulWidget {
  const KBottomNavBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
  });

  final List<Widget> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;

  @override
  State<KBottomNavBar> createState() => _KBottomNavBarState();
}

class _KBottomNavBarState extends State<KBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.items.length, (index) {
          return InkWell(
            onTap: () {
              widget.onTap?.call(index);
            },
            child: widget.items[index],
          );
        }),
      ),
    );
  }
}

class KBottomNavItem extends StatelessWidget {
  const KBottomNavItem({
    super.key,
    required this.svgIcon,
    this.isSelected = false,
    this.counterWidget,
  });

  final String svgIcon;
  final bool isSelected;
  final Widget? counterWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgIcon(
            svgIcon,
            size: 23,
            color: isSelected ? AppColors.orangeColor : AppColors.whiteColor,
          ),
          if (counterWidget != null)
            Positioned(
              top: 0,
              right: 0,
              child: counterWidget!,
            )
        ],
      ),
    );
  }
}
