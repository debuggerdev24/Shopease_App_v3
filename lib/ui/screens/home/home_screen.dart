import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/screens/app_tour/app_tour.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/inventory_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/expiry_status.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<InventoryProvider>().getInventoryItems().then((_) {
          if (SharedPrefs().appTour != true) showInventoryTutorial();
        });
      },
    );
  }

  void showInventoryTutorial() {
    getInventoryTutorial(
      onFinish: () => AppNavigator.goToBranch(1),
      onSkip: () {
        AppNavigator.goToBranch(1);
        return true;
      },
    ).show(
      context: AppNavigator.shellNavigatorHome.currentContext ?? context,
    );
  }

  @override
  Widget build(BuildContext context) {
    // log("----------------------------> ${}");
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: GlobalText(
              "Inventory List",
              textStyle: appBarTitleStyle.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 24.sp),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(provider.products),
                  );
                },
                icon: SvgIcon(
                  AppAssets.search,
                  size: 20.sp,
                  color: AppColors.blackGreyColor,
                ),
              ),
              AppIconButton(
                  key: scanInvButtonKey,
                  onTap: () {
                    context.pushNamed(AppRoute.scanAndAddScreen.name);
                  },
                  child: const SvgIcon(
                    AppAssets.scanner,
                    size: 23,
                    color: AppColors.blackGreyColor,
                  )),
              AppIconButton(
                key: addInvButtonKey,
                onTap: () {
                  context.pushNamed(
                    AppRoute.addInventoryForm.name,
                    extra: {'isEdit': false},
                  );

                  // showAddInventoryOptions();
                },
                child: const SvgIcon(
                  AppAssets.add,
                  size: 20,
                  color: AppColors.orangeColor,
                ),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.products.isEmpty
                  ? _buildAdDInvWidget()
                  : Column(
                      children: [
                        _buildInventoryHeadingBar(provider),
                        Expanded(
                          child: provider.filteredProducts.isEmpty
                              ? Center(
                                  child: GlobalText(
                                    'No matching results found.',
                                    textStyle: textStyle16,
                                  ),
                                )
                              : _buildProductsList(provider),
                        )
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildInventoryHeadingBar(InventoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          10.horizontalSpace,
          Text(
            '${provider.filteredProducts.length} Products',
            style: textStyle16.copyWith(fontSize: 18),
          ),
          const Spacer(),
          InkWell(
            onTap: showFilterSheet,
            child: SvgPicture.asset(
              (!provider.selectValue)
                  ? AppAssets.filterIcon
                  : AppAssets.selectedFilterIcon,
              width: 22.h,
              height: 22.h,
            ),
          ),
          8.w.horizontalSpace,
        ],
      ),
    );
  }

  Widget _buildProductsList(InventoryProvider provider) {
    List<Product> sortedList = provider.filteredProducts;
    // [...provider.filteredProducts]..sort(
    //     (a, b) => a.name
    //         .toString()
    //         .toLowerCase()
    //         .compareTo(b.name.toString().toLowerCase()),
    //   );

    return ListView.builder(
      itemCount: sortedList.length,
      // separatorBuilder: (context, index) => 10.verticalSpace,
      itemBuilder: (BuildContext context, int index) {
        return InventoryTile(
          key: ValueKey("tile_$index${sortedList[index].productName}"),
          onLongPress: () {
            context.goNamed(
              AppRoute.multipleInventorySelection.name,
            );
          },
          product: sortedList[index],
          onTap: () {
            context.pushNamed(AppRoute.productDetail.name,
                extra: {'product': sortedList[index]});
          },
          onAddToCart: () {
            if (sortedList[index].isInChecklist == true) {
              context.read<ChecklistProvider>().deleteChecklistItems(
                  itemIds: [sortedList[index].itemId!],
                  onSuccess: () {
                    //in_stock_quantity
                    provider
                        .addToChecklist([sortedList[index]], context, false);
                  });
            } else {
              context.read<ChecklistProvider>().putChecklistFromInventory(
                data: [sortedList[index].itemId!],
                onSuccess: () {
                  log(sortedList[index].inStockQuantity);
                  provider.addToChecklist([sortedList[index]], context, false);
                },
              );
            }
          },
          onDelete: () {
            provider.deletInventoryItems(
                itemIds: [sortedList[index].itemId!],
                onSuccess: () {
                  CustomToast.showSuccess(context, 'Successfully deleted');
                });
          },
          onInventoryChange: (newType) {
            provider.changeInventoryType(
              sortedList[index].itemId!,
              newType,
            );
          },
          onChangedInStockQuantity: (q) {
            provider.changeInStockQuantity(
              sortedList[index].itemId!,
              q,
            );
          },
        );
      },
    );
  }

  _buildAdDInvWidget() => BounceInUp(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            120.h.verticalSpace,
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(AppAssets.addInventory)),
              ),
            ),
            10.h.verticalSpace,
            GlobalText(
              'Add your First Inventory',
              textStyle: textStyle16.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackGreyColor),
            ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: AppButton(
                  onPressed: () {
                    // showAddInventoryOptions();
                    context.pushNamed(AppRoute.addInventoryForm.name);
                  },
                  text: 'Add an Inventory'),
            ),
          ],
        ),
      );

  Widget buildInventoryContainer(
      String text, String level, InventoryProvider provider, String value) {
    return GestureDetector(
      onTap: () {
        provider.changeFilterInventoryLevel(value.toLowerCase());
      },
      child: Container(
        width: 111.w,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(level),
            10.horizontalSpace,
            Text(
              text,
              style: textStyle14.copyWith(color: AppColors.primaryColor),
            ),
            if (provider.selectedInventoryLevelFilter ==
                value.toLowerCase()) ...[
              10.horizontalSpace,
              SvgIcon(
                AppAssets.check,
                color: AppColors.primaryColor,
                size: 10.h,
              ),
            ]
          ],
        ),
      ),
    );
  }

  showFilterSheet() async {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Consumer<InventoryProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        GlobalText('Filters', textStyle: textStyle20SemiBold),
                  ),
                  20.h.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    child: GlobalText(
                      'Filter by category',
                      textStyle: textStyle16.copyWith(fontSize: 15.sp),
                    ),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: Utils.categories
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: AppChip(
                              isnotselected: true,
                              text: e.categoryName,
                              isSelected: provider.selectedCategoryFilters
                                  .contains(e.categoryId),
                              onTap: () {
                                provider.changeFilterCategoty(e.categoryId);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  10.h.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    child: GlobalText(
                      'Expiry Details',
                      textStyle: textStyle16.copyWith(fontSize: 15.sp),
                    ),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: ExpiryStatus.values
                        .map(
                          (e) => e == ExpiryStatus.normal
                              ? const SizedBox.shrink()
                              : AppChip(
                                  text: e.displayText,
                                  isSelected:
                                      provider.selectedExpiryFilter == e,
                                  onTap: () => provider.changeFilterExpiry(e),
                                ),
                        )
                        .toList(),
                  ),
                  10.h.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    child: GlobalText(
                      'Filter by Inventory Level',
                      textStyle: textStyle16.copyWith(fontSize: 15.sp),
                    ),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: [
                      buildInventoryContainer(
                          'High', AppAssets.inventoryHigh, provider, "high"),
                      buildInventoryContainer(
                          'Med', AppAssets.inventoryMid, provider, "medium"),
                      buildInventoryContainer(
                          'Low', AppAssets.inventoryLow, provider, "low"),
                    ],
                  ),
                  25.h.verticalSpace,
                  Center(
                    child: AppButton(
                        colorType: AppButtonColorType.primary,
                        onPressed: () {
                          provider.filterProducts();
                          context.pop();
                        },
                        text: 'Apply'),
                  ),
                  10.h.verticalSpace,
                  Center(
                    child: AppButton(
                        colorType: AppButtonColorType.greyed,
                        onPressed: () {
                          context.pop();
                        },
                        text: 'Cancel'),
                  ),
                  10.h.verticalSpace,
                ],
              ),
            );
          },
        );
      },
    );
  }

  showAddInventoryOptions() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20.h,
            children: [
              GlobalText(
                textAlign: TextAlign.center,
                "How would you like to add the new product?",
                textStyle: textStyle18,
              ),
              AppButton(
                onPressed: () {
                  context.pop();
                  context.pushNamed(
                    AppRoute.addInventoryForm.name,
                    extra: {'isEdit': false},
                  );
                },
                text: "Add Manually",
              ),
              AppButton(
                onPressed: () {
                  context.pop();
                  context.pushNamed(AppRoute.uploadReceiptScreen.name);
                },
                colorType: AppButtonColorType.secondary,
                text: "Receipt scan",
              ),
            ],
          ),
        );
      },
    );
  }
}
