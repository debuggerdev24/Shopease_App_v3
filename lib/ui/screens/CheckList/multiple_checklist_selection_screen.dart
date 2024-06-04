import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/checklist_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/back_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/multiple_product_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/product_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MultipleChecklistSelectionScreen extends StatefulWidget {
  const MultipleChecklistSelectionScreen({super.key});

  @override
  State<MultipleChecklistSelectionScreen> createState() =>
      _MultipleChecklistSelectionScreenState();
}

class _MultipleChecklistSelectionScreenState
    extends State<MultipleChecklistSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlobalText('Checkout'),
        leading: KBackButton(
          onBackClick: () {
            context.read<ChecklistProvider>().clearSelectedProducts();
          },
        ),
        actions: _buildActions(context.read<ChecklistProvider>()),
      ),
      body: Consumer<ChecklistProvider>(builder: (context, provider, _) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                CheckboxListTile(
                  value: provider.isAllSelected,
                  onChanged: provider.changeIsAllSelected,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Row(
                    children: [
                      10.horizontalSpace,
                      Text(
                        'Mark as done (${provider.selectedChecklists.length}/${provider.checklist.length})',
                        style: textStyle16.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(AppRoute.selectShop.name);
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.orangeColor),
                        child: Text(
                          provider.selectedShop == null
                              ? 'Select shop'
                              : provider.selectedShop!.shopName,
                        ),
                      ),
                      8.w.horizontalSpace,
                    ],
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: provider.checklist.length,
                    separatorBuilder: (context, index) => 10.h.verticalSpace,
                    itemBuilder: (BuildContext context, int index) {
                      return MultipleProductTile(
                        product: provider.checklist[index],
                        onLongPress: () {},
                        isSelected: provider.selectedChecklists
                            .contains(provider.checklist[index]),
                        onSelectionChanges: (value) {
                          provider.addProductToSelected(
                            value,
                            provider.checklist[index],
                          );
                        },
                      );
                    }),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: AppButton(
                  isLoading: provider.isLoading,
                  onPressed: () async {
                    if (provider.selectedChecklists.isEmpty) {
                      CustomToast.showWarning(
                          context, 'Please select product first.');
                      return;
                    }

                    if (provider.selectedShop == null) {
                      CustomToast.showWarning(context, 'Please select shop');
                      return;
                    }

                    await provider.putInventoryFromChecklist(
                      itemIds: provider.selectedChecklists
                          .map((e) => e.itemId!)
                          .toList(),
                      onSuccess: () async {
                        CustomToast.showSuccess(context,
                            '${provider.selectedChecklists.length} Products purchased.');
                        context.goNamed(AppRoute.uploadInvoice.name);

                        // context.goNamed(AppRoute.checkList.name);
                      },
                    );
                    // provider.clearSelectedProducts();
                  },
                  text: 'Buy products (${provider.selectedChecklists.length})'),
            )
          ],
        );
      }),
    );
  }

  List<Widget> _buildActions(ChecklistProvider provider) => [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: ChecklistSearchDelegate(provider.checklist),
            );
          },
          icon: const SvgIcon(
            AppAssets.search,
            size: 24,
            color: AppColors.blackGreyColor,
          ),
        ),
        AppIconButton(
          onTap: () {
            context.pushNamed(
              AppRoute.scanAndAddScreen.name,
              extra: {'isFromChecklist': true},
            );
          },
          child: const SvgIcon(
            AppAssets.scanner,
            size: 23,
            color: AppColors.blackGreyColor,
          ),
        ),
        AppIconButton(
          onTap: () {
            context.pushNamed(
              AppRoute.addChecklistForm.name,
              extra: {'isEdit': false},
            );
          },
          child: const SvgIcon(
            AppAssets.add,
            size: 23,
            color: AppColors.orangeColor,
          ),
        ),
      ];

  showFilterSheet() async {
    return showModalBottomSheet(
        showDragHandle: true,
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            height: 480.h,
            padding: EdgeInsets.symmetric(horizontal: 13.sp, vertical: 5.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        GlobalText('Filters', textStyle: textStyle20SemiBold),
                  ),
                  20.h.verticalSpace,
                  GlobalText(
                    'Filter by category',
                    textStyle: textStyle16.copyWith(fontSize: 15.sp),
                  ),
                  const Wrap(
                    direction: Axis.horizontal,
                    children: [
                      // AppChip(text: 'Fresh Fruits'),
                      // AppChip(text: 'Category', isSelected: true),
                      // AppChip(text: 'Fresh Vegetables'),
                      // AppChip(text: 'Other Category'),
                    ],
                  ),
                  10.h.verticalSpace,
                  GlobalText(
                    'Filter by Inventory Level',
                    textStyle: textStyle16.copyWith(fontSize: 15.sp),
                  ),
                  10.h.verticalSpace,
                  Wrap(
                    children: [
                      // buildInventoryContainer('High', AppAssets.inventoryHigh),
                      // buildInventoryContainer('Medium', AppAssets.inventoryMid),
                      // buildInventoryContainer('Low', AppAssets.inventoryLow),
                    ],
                  ),
                  50.h.verticalSpace,
                  Center(
                    child: AppButton(
                        colorType: AppButtonColorType.secondary,
                        onPressed: () {
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
            ),
          );
        });
  }
}

Widget buildInventoryContainer(String text, String level) {
  return Container(
    width: 100.w,
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
      ],
    ),
  );
}
