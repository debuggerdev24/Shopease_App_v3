import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  // late TabController _controller;

  // final TextEditingController _textController = TextEditingController();

  // List<Widget> pages = [
  //   const HomeScreen(),
  //   const ListingsScreen(),
  //   Material(),
  //   Material(),
  //   Material(),
  //   // const MarketScreen(),
  //   // const MessageScreen(),
  //   // const ProfileScreen(),
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _textController.dispose();
    super.dispose();
  }

  void goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: widget.navigationShell,
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return KBottomNavBar(
      currentIndex: widget.navigationShell.currentIndex,
      onTap: (index) {
        // setState(() {
        //   selectedIndex = index;
        // });

        if (index == 0) {
          context.read<InventoryProvider>().getInventoryItems();
        }

        if (index == 1) {
          context.read<ChecklistProvider>().getChecklistItems();
        }

        if (index == 2) {
          context.read<ProfileProvider>().getProfile();
        }

        goToBranch(index);
      },
      items: [
        KBottomNavItem(
          svgIcon: AppAssets.menu,
          isSelected: widget.navigationShell.currentIndex == 0,
        ),
        KBottomNavItem(
          svgIcon: AppAssets.addtocart,
          isSelected: widget.navigationShell.currentIndex == 1,
        ),
        KBottomNavItem(
          isSelected: widget.navigationShell.currentIndex == 2,
          svgIcon: AppAssets.person,
        ),
        KBottomNavItem(
          isSelected: widget.navigationShell.currentIndex == 3,
          svgIcon: AppAssets.notification,
        )
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

  final List<KBottomNavItem> items;
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
        children: widget.items.indexed
            .map((e) => InkWell(
                  onTap: () {
                    widget.onTap?.call(e.$1);
                  },
                  child: e.$2,
                ))
            .toList(),
      ),
    );
  }
}

class KBottomNavItem extends StatelessWidget {
  const KBottomNavItem({
    super.key,
    required this.svgIcon,
    this.isSelected = false,
  });

  final String svgIcon;
  final bool isSelected;

  KBottomNavItem copyWith(TextStyle? labelStyle) => KBottomNavItem(
        svgIcon: svgIcon,
      );

  @override
  Widget build(BuildContext context) {
    return SvgIcon(
      svgIcon,
      size: 23,
      color: isSelected ? AppColors.orangeColor : AppColors.whiteColor,
    );
  }
}
