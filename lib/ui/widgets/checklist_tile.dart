import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/product_image_widget.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ChecklistTile extends StatefulWidget {
  const ChecklistTile({
    super.key,
    required this.product,
    this.onDelete,
    this.onLongPress,
    this.isSlideEnabled = true,
    required this.isSelected,
    this.onSelectionChanges,
    this.showCheckbox = false,
    this.onTap,
    this.onChangedRequiredQuantity,
  });

  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSlideEnabled;
  final bool isSelected;
  final bool showCheckbox;
  final Function(bool?)? onSelectionChanges;
  final ValueChanged<String>? onChangedRequiredQuantity;

  @override
  State<ChecklistTile> createState() => _ChecklistTileState();
}

class _ChecklistTileState extends State<ChecklistTile>
    with SingleTickerProviderStateMixin {
  late final SlidableController _slideController;

  late final ValueNotifier<int> requiredQuantityListenable;

  @override
  void initState() {
    super.initState();
    _slideController = SlidableController(this);
    requiredQuantityListenable =
        ValueNotifier(int.tryParse(widget.product.quantity) ?? 0);
  }

  @override
  void didUpdateWidget(ChecklistTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.quantity != widget.product.quantity) {
      requiredQuantityListenable.value = int.parse(widget.product.quantity);
    }
  }

  @override
  dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _slideController,
      endActionPane: widget.isSlideEnabled
          ? _buildRightSwipeActions(widget.product)
          : null,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Opacity(
          opacity: widget.isSelected ? .75 : 1,
          child: Container(
            color: widget.isSelected
                ? Colors.grey[200]!.withValues(alpha: 0.05)
                : Colors.grey[800]!.withValues(alpha: 0.05),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                if (widget.showCheckbox)
                  Transform.scale(
                    scale: 1.25,
                    child: Checkbox(
                      value: widget.isSelected,
                      onChanged: widget.onSelectionChanges,
                      activeColor: AppColors.greenColor,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductImageWidget(
                    product: widget.product,
                    height: 100.h,
                    width: 100.h,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "${widget.product.productName!} (${widget.product.quantity})",
                        maxLines: 10,
                        style: textStyle16.copyWith(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          decoration: widget.isSelected
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (widget.product.brand.toString().isNotEmpty)
                        AppChip(text: widget.product.brand ?? ''),
                      SizedBox(width: 10.h),
                    ],
                  ),
                ),
                SizedBox(width: 25.sp),
                SvgPicture.asset(
                  widget.product.itemLevel == InventoryType.high.name
                      ? AppAssets.inventoryHigh
                      : widget.product.itemLevel == InventoryType.medium.name
                          ? AppAssets.inventoryMid
                          : AppAssets.inventoryLow,
                  width: 18.h,
                  height: 18.h,
                ),
                SizedBox(
                    width: 10.sp), // Assuming 10.horizontalSpace is a SizedBox
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRightSwipeActions(Product product) => ActionPane(
        motion: const ScrollMotion(),
        extentRatio: .75,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                int oldQty = requiredQuantityListenable.value;
                showAddQuantitySheet(context, oldQty, requiredQuantityListenable);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5.w),
                color: AppColors.lightGreyColor.withAlpha(20),
                child: ValueListenableBuilder(
                  valueListenable: requiredQuantityListenable,
                  builder: (context, value, _) {
                    return Text(
                      maxLines: 10,
                      "Qty : ${value.toString()}",
                      style: textStyle16.copyWith(
                        color: AppColors.primaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                    //   AppChip(
                    //   text:
                    // );
                  },
                ),
                // Row(
                //                     mainAxisSize: MainAxisSize.min,
                //                     children: [
                //                       Expanded(
                //                         child: GestureDetector(
                //                           onTap: () {
                //                             if (requiredQuantityListenable.value == 1) return;
                //                             requiredQuantityListenable.value -= 1;
                //                             // widget.onChangedInStockQuantity?.call(
                //                             //   inStockQuantityListenable.value.toString(),
                //                             // );
                //                           },
                //                           child: const Icon(Icons.remove),
                //                         ),
                //                       ),
                //                       Expanded(
                //                         child: GestureDetector(
                //                           onTap: () {
                //                             requiredQuantityListenable.value += 1;
                //                             // widget.onChangedInStockQuantity?.call(
                //                             //   inStockQuantityListenable.value.toString(),
                //                             // );
                //                           },
                //                           child: const Icon(Icons.add),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                   GestureDetector(
                //                     onTap: () {
                //                       widget.onChangedRequiredQuantity?.call(
                //                         requiredQuantityListenable.value.toString(),
                //                       );
                //                     },
                //                     child: Text(
                //                       "Done",
                //                       style:
                //                       textStyle14.copyWith(color: AppColors.primaryColor),
                //                     ),
                //                   )
                //todo ----------------------
                // Column(
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     ValueListenableBuilder(
                //       valueListenable: requiredQuantityListenable,
                //       builder: (context, value, _) {
                //         return AppChip(
                //           text: value.toString(),
                //         );
                //       },
                //     ),
                //     15.h.verticalSpace,
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               if (requiredQuantityListenable.value == 0) return;
                //               requiredQuantityListenable.value -= 1;
                //               widget.onChangedRequiredQuantity?.call(
                //                 requiredQuantityListenable.value.toString(),
                //               );
                //             },
                //             child: const Icon(Icons.remove),
                //           ),
                //         ),
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               requiredQuantityListenable.value += 1;
                //               widget.onChangedRequiredQuantity?.call(
                //                 requiredQuantityListenable.value.toString(),
                //               );
                //             },
                //             child: const Icon(Icons.add),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.replace,
            forgroundColor: AppColors.primaryColor,
            onTap: () {
              log("---------------------> RequireQty : ${requiredQuantityListenable.value}");

              _showReplaceBrandSheet(product);
            },
          ),
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.delete,
            onTap: () {
              _showDeleteSheet(product);
            },
            forgroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.redColor,
          ),
        ],
      );

  Future<dynamic> showAddQuantitySheet(
      BuildContext context, int oldQty, ValueNotifier<int> listenAbleValue) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Quantity",
              style: textStyle24SemiBold.copyWith(fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.h, bottom: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.w,
                children: [
                  IconButton(
                      onPressed: () {
                        if (listenAbleValue.value > 1) {
                          listenAbleValue.value -= 1;
                        }
                      },
                      color: AppColors.orangeColor,
                      icon: const Icon(Icons.remove)),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 18.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(color: AppColors.mediumGreyColor)),
                    child: ValueListenableBuilder<int>(
                      valueListenable: requiredQuantityListenable,
                      builder:
                          (BuildContext context, int value, Widget? child) =>
                              Text(
                        value.toString(),
                        style: textStyle24SemiBold.copyWith(
                          color: AppColors.orangeColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      requiredQuantityListenable.value += 1;
                      // widget.onChangedInStockQuantity?.call(
                      //   inStockQuantityListenable.value.toString(),
                      // );
                    },
                    color: AppColors.orangeColor,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            AppButton(
              onPressed: () {
                widget.onChangedRequiredQuantity?.call(
                  requiredQuantityListenable.value.toString(),
                );
                context.pop();
              },
              text: "Save",
            ),
            20.h.verticalSpace,
            AppButton(
              colorType: AppButtonColorType.secondary,
              onPressed: () {
                requiredQuantityListenable.value = oldQty;
                context.pop();
              },
              text: "Cancel",
            ),
            30.h.verticalSpace,
          ],
        );
      },
    );
  }

  _showReplaceBrandSheet(Product product) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
              padding: EdgeInsets.all(20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Replace Brand',
                    style: textStyle18SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  Text(
                    'Some times good to try new brand to get the same flavour.',
                    style: textStyle16,
                    textAlign: TextAlign.start,
                  ),
                  40.h.verticalSpace,
                  AppButton(
                      onPressed: () {
                        _slideController.close();
                        context.pop();
                        context
                            .pushNamed(AppRoute.scanAndAddScreen.name, extra: {
                          'isReplace': true,
                          'isFromChecklist': true,
                          // 'isInvoice': false,
                          'oldId': widget.product.itemId,
                        });
                      },
                      colorType: AppButtonColorType.primary,
                      text: 'Scan And Replace'),
                  10.verticalSpace,
                  AppButton(
                    onPressed: () {
                      _slideController.close();
                      context.pop();
                      context.pushNamed(AppRoute.addChecklistForm.name, extra: {
                        'isReplace': true,
                        'oldId': widget.product.itemId,
                      });
                    },
                    text: 'Replace Manually',
                    colorType: AppButtonColorType.secondary,
                  ),
                ],
              ),
            ));
  }

  _showDeleteSheet(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(10.h),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you sure want to delete from\nChecklist?',
              style: textStyle18SemiBold,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            DeleteButton(
                onPressed: () {
                  widget.onDelete?.call();
                  _slideController.close();
                  context.pop();
                },
                text: 'Delete'),
            10.verticalSpace,
            AppButton(
              onPressed: () {
                _slideController.close();
                context.pop();
              },
              text: 'Cancel',
              colorType: AppButtonColorType.greyed,
            ),
          ],
        ),
      ),
    );
  }
}
