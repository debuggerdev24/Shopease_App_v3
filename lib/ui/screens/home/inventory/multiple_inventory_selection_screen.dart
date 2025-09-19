import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/multiple_product_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

class MultipleInventorySelectionScreen extends StatefulWidget {
  const MultipleInventorySelectionScreen({super.key});

  @override
  State<MultipleInventorySelectionScreen> createState() =>
      _MultipleInventorySelectionScreenState();
}

class _MultipleInventorySelectionScreenState
    extends State<MultipleInventorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: GlobalText('${provider.selectedProducts.length} Selected'),
          actions: [
            IconButton(
              onPressed: () async {
                await provider.deletInventoryItems(
                  itemIds:
                      provider.selectedProducts.map((e) => e.itemId!).toList(),
                  onSuccess: () {
                    CustomToast.showSuccess(context, 'Successfully deleted.');
                    context.pop();
                  },
                );
              },
              icon: SvgIcon(
                AppAssets.delete,
                size: 20.h,
              ),
            ),
            IconButton(
              onPressed: () async {
                context.read<ChecklistProvider>().putChecklistFromInventory(
                      data: provider.selectedProducts
                          .map((e) => e.itemId!)
                          .toList(),
                      onSuccess: () {
                        provider.addToChecklist(
                            provider.selectedProducts, context, false);
                        CustomToast.showSuccess(context, 'Added successfully.');
                        context.pop();
                      },
                    );
              },
              icon: SvgIcon(
                AppAssets.addCart,
                size: 19.h,
                color: AppColors.primaryColor,
              ),
            ),
            20.w.horizontalSpace,
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                        AppAssets.selectedFilterIcon,
                        width: 22.h,
                        height: 22.h,
                      ),
                    ),
                    8.w.horizontalSpace,
                  ],
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: provider.filteredProducts.length,
                  separatorBuilder: (context, index) => 10.h.verticalSpace,
                  itemBuilder: (BuildContext context, int index) {
                    return MultipleProductTile(
                      product: provider.filteredProducts[index],
                      isSelected: provider.selectedProducts
                          .contains(provider.filteredProducts[index]),
                      onSelectionChanges: (value) {
                        provider.addProductToSelected(
                            value, provider.filteredProducts[index]);
                      },
                    );
                  }),
            ],
          ),
        ),
      );
    });
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
              padding: EdgeInsets.only(left: 14),
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

  // showFilterSheet() async {
  //   return showModalBottomSheet(
  //       showDragHandle: true,
  //       enableDrag: true,
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return Consumer<InventoryProvider>(builder: (context, provider, _) {
  //           return Container(
  //             alignment: Alignment.center,
  //             height: 480.h,
  //             padding: EdgeInsets.symmetric(horizontal: 13.sp, vertical: 5.sp),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Center(
  //                     child:
  //                         GlobalText('Filters', textStyle: textStyle20SemiBold),
  //                   ),
  //                   20.h.verticalSpace,
  //                   GlobalText(
  //                     'Filter by category',
  //                     textStyle: textStyle16.copyWith(fontSize: 15.sp),
  //                   ),

  //                   Wrap(
  //                     direction: Axis.horizontal,
  //                     children: Constants.categories
  //                         .map(
  //                           (e) => Padding(
  //                             padding: EdgeInsets.only(top: 12.h),
  //                             child: AppChip(
  //                               isnotselected: true,
  //                               text: e.categoryName,
  //                               isSelected: provider.selectedCategoryFilters
  //                                   .contains(e.categoryId),
  //                               onTap: () {
  //                                 provider.changeFilterCategoty(e.categoryId);
  //                               },
  //                             ),
  //                           ),
  //                         )
  //                         .toList(),
  //                   ),

  //                   // const Wrap(
  //                   //   direction: Axis.horizontal,
  //                   //   children: [
  //                   //     AppChip(text: 'Fresh Fruits'),
  //                   //     AppChip(text: 'Category', isSelected: true),
  //                   //     AppChip(text: 'Fresh Vegetables'),
  //                   //     AppChip(text: 'Other Category'),
  //                   //   ],
  //                   // ),
  //                   10.h.verticalSpace,
  //                   GlobalText(
  //                     'Filter by Inventory Level',
  //                     textStyle: textStyle16.copyWith(fontSize: 15.sp),
  //                   ),
  //                   10.h.verticalSpace,
  //                   Row(
  //                     children: [
  //                       buildInventoryContainer(
  //                           'High', AppAssets.inventoryHigh, provider),
  //                       buildInventoryContainer(
  //                           'Medium', AppAssets.inventoryMid, provider),
  //                       buildInventoryContainer(
  //                           'Low', AppAssets.inventoryLow, provider),
  //                     ],
  //                   ),
  //                   // Wrap(
  //                   //   children: [
  //                   //     buildInventoryContainer('High', AppAssets.inventoryHigh),
  //                   //     buildInventoryContainer('Medium', AppAssets.inventoryMid),
  //                   //     buildInventoryContainer('Low', AppAssets.inventoryLow),
  //                   //   ],
  //                   // ),
  //                   50.h.verticalSpace,
  //                   Center(
  //                     child: AppButton(
  //                         colorType: AppButtonColorType.primary,
  //                         onPressed: () {
  //                           provider.filterProducts();
  //                           context.pop();
  //                         },
  //                         text: 'Apply'),
  //                   ),
  //                   10.h.verticalSpace,
  //                   Center(
  //                     child: AppButton(
  //                         colorType: AppButtonColorType.greyed,
  //                         onPressed: () {
  //                           context.pop();
  //                         },
  //                         text: 'Cancel'),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //       });
  // }
}

Widget buildInventoryContainer(
    String text, String level, InventoryProvider provider) {
  return GestureDetector(
    onTap: () {
      provider.changeFilterInventoryLevel(text.toLowerCase());
    },
    child: Container(
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
          if (provider.selectedInventoryLevelFilter == text.toLowerCase()) ...[
            10.horizontalSpace,
            SvgIcon(
              AppAssets.check,
              color: AppColors.primaryColor,
              size: 10.h,
            ),
          ],
        ],
      ),
    ),
  );
}
