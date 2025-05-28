import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/screens/app_tour/app_tour.dart';
import 'package:shopease_app_flutter/ui/screens/home/inventory_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/product_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<InventoryProvider>().getInventoryItems();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  // show tutorial
                  getTutorial().show(context: context);

                  // showSearch(
                  //     context: context,
                  //     delegate: ProductSearchDelegate(provider.products));
                },
                icon: SvgIcon(
                  AppAssets.search,
                  size: 20.sp,
                  color: AppColors.blackGreyColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: AppIconButton(
                    key: scanInvButtonKey,
                    onTap: () {
                      context.pushNamed(AppRoute.scanAndAddScreen.name);
                    },
                    child: const SvgIcon(
                      AppAssets.scanner,
                      size: 23,
                      color: AppColors.blackGreyColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: AppIconButton(
                  key: addInvButtonKey,
                  onTap: () {
                    context.pushNamed(
                      AppRoute.addInventoryForm.name,
                      extra: {'isEdit': false},
                    );
                  },
                  child: const SvgIcon(
                    AppAssets.add,
                    size: 20,
                    color: AppColors.orangeColor,
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
    return ListView.separated(
        shrinkWrap: true,
        reverse: false,
        itemCount: provider.filteredProducts.length,
        separatorBuilder: (context, index) => 10.verticalSpace,
        itemBuilder: (BuildContext context, int index) {
          return ProductTile(
            onLongPress: () {
              context.goNamed(
                AppRoute.multipleInventorySelection.name,
              );
            },
            product: provider.filteredProducts[index],
            onTap: () {
              context.pushNamed(AppRoute.productDetail.name,
                  extra: {'product': provider.filteredProducts[index]});
            },
            onAddToCart: () {
              if (provider.filteredProducts[index].isInChecklist == true) {
                context.read<ChecklistProvider>().deleteChecklistItems(
                    itemIds: [provider.filteredProducts[index].itemId!],
                    onSuccess: () {
                      provider.addToChecklist(
                          [provider.filteredProducts[index]], context, false);
                    });
              } else {
                context.read<ChecklistProvider>().putChecklistFromInventory(
                  data: [provider.filteredProducts[index].itemId!],
                  onSuccess: () {
                    provider.addToChecklist(
                        [provider.filteredProducts[index]], context, false);
                  },
                );
              }
            },
            onDelete: () {
              provider.deletInventoryItems(
                  itemIds: [provider.filteredProducts[index].itemId!],
                  onSuccess: () {
                    CustomToast.showSuccess(context, 'Successfully deleted');
                  });
            },
            onInventoryChange: (newType) {
              provider.changeInventoryType(
                provider.filteredProducts[index].itemId!,
                newType,
              );
            },
          );
        });
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
                    context.pushNamed(AppRoute.addInventoryForm.name);
                  },
                  text: 'Add an Inventory'),
            ),
          ],
        ),
      );

  Widget buildInventoryContainer(
      String text, String level, InventoryProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.changeFilterInventoryLevel(text.toLowerCase());
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
                text.toLowerCase()) ...[
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
          return Consumer<InventoryProvider>(builder: (context, provider, _) {
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
                      'Filter by Inventory Level',
                      textStyle: textStyle16.copyWith(fontSize: 15.sp),
                    ),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: [
                      buildInventoryContainer(
                          'High', AppAssets.inventoryHigh, provider),
                      buildInventoryContainer(
                          'Medium', AppAssets.inventoryMid, provider),
                      buildInventoryContainer(
                          'Low', AppAssets.inventoryLow, provider),
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
                ],
              ),
            );
          });
        });
  }
}
