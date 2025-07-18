import 'dart:developer';

import 'package:flutter/foundation.dart';
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
import 'package:shopease_app_flutter/utils/enums/expiry_status.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class InventoryTile extends StatefulWidget {
  const InventoryTile({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
    this.onInventoryChange,
    this.onAddToCart,
    this.onLongPress,
    this.check,
    this.isSlideEnabled = true,
    this.onSelectionChanges,
    this.onChangedInStockQuantity,
  });

  final Product product;
  final bool? check;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;
  final VoidCallback? onLongPress;
  final bool isSlideEnabled;
  final Function(bool?)? onSelectionChanges;
  final Function(InventoryType type)? onInventoryChange;
  final ValueChanged<String>? onChangedInStockQuantity;

  @override
  State<InventoryTile> createState() => _InventoryTileState();
}

class _InventoryTileState extends State<InventoryTile>
    with SingleTickerProviderStateMixin {
  late SlidableController _slideController;

  late final ValueNotifier<int> inStockQuantityListenable;

  @override
  void initState() {
    super.initState();
    _slideController = SlidableController(this);
    inStockQuantityListenable =
        ValueNotifier(int.tryParse(widget.product.inStockQuantity) ?? 0);
  }

  @override
  void didUpdateWidget(InventoryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.quantity != widget.product.quantity) {
      inStockQuantityListenable.value = int.parse(widget.product.quantity);
    }
  }

  @override
  dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.product.isInChecklist --> ${widget.product.isInChecklist} ");
    return Padding(
      key: ObjectKey(widget.product.itemId),
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Slidable(
          controller: _slideController,
          endActionPane: !widget.isSlideEnabled
              ? null
              : _buildRightSwipeActions(widget.product),
          startActionPane: !widget.isSlideEnabled
              ? null
              : _buildLeftSwipeActions(widget.product),
          child: Stack(
            children: [
              Container(
                color: Colors.grey[800]!.withValues(alpha: 0.05),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
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
                            maxLines: 10,
                            "${widget.product.productName!} (${widget.product.inStockQuantity})",
                            overflow: TextOverflow.ellipsis,
                            style: textStyle16.copyWith(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (widget.product.brand.toString().isNotEmpty)
                            AppChip(text: widget.product.brand ?? '')
                        ],
                      ),
                    ),
                    if (widget.product.isInChecklist == true) ...[
                      20.horizontalSpace,
                      SvgIcon(
                        AppAssets.succcessCart,
                        size: 20.sp,
                        color: AppColors.greenColor,
                      ),
                    ],
                    20.horizontalSpace,
                    SvgPicture.asset(
                      widget.product.itemLevel == InventoryType.high.name
                          ? AppAssets.inventoryHigh
                          : widget.product.itemLevel ==
                                  InventoryType.medium.name
                              ? AppAssets.inventoryMid
                              : AppAssets.inventoryLow,
                      width: 18.h,
                      height: 18.h,
                    ),
                    SizedBox(width: 10.sp),
                  ],
                ),
              ),
              if (widget.product.expiryStatus == ExpiryStatus.expired)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  _buildRightSwipeActions(Product product) => ActionPane(
        motion: const ScrollMotion(),
        extentRatio: .75,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: inStockQuantityListenable,
            builder: (context, value, child) => Expanded(
              child: GestureDetector(
                onTap: () {
                  int oldQty = inStockQuantityListenable.value;
                  showAddQuantitySheet(context, oldQty,inStockQuantityListenable);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 5.w),
                  color: AppColors.lightGreyColor.withAlpha(20),
                  child: Text(
                    "Qty : ${value.toString()}",
                    style: textStyle16.copyWith(
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppSlidableaction(
            isRight: true,
            icon: product.isInChecklist == true
                ? AppAssets.rmCart
                : AppAssets.addCart,
            forgroundColor: product.isInChecklist == true
                ? AppColors.redColor
                : AppColors.primaryColor,
            onTap: () {
              widget.onAddToCart?.call();
              _slideController.close();
            },
          ),
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.delete,
            onTap: () {
              _showDeleteSheet(
                product,
              );
            },
            forgroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.redColor,
          ),
        ],
      );

  Future<dynamic> showAddQuantitySheet(BuildContext context, int oldQty,ValueNotifier<int> listenAbleValue) {
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
                          style: textStyle24SemiBold.copyWith(
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18.h, bottom: 30.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10.w,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (listenAbleValue.value >
                                        1) {
                                      listenAbleValue.value -= 1;
                                    }
                                  },
                                  color: AppColors.orangeColor,
                                  icon: const Icon(Icons.remove)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 18.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22.r),
                                    border: Border.all(
                                        color: AppColors.mediumGreyColor)),
                                child: ValueListenableBuilder<int>(
                                  valueListenable: inStockQuantityListenable,
                                  builder: (BuildContext context, int value,
                                          Widget? child) =>
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
                                  inStockQuantityListenable.value += 1;
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
                            widget.onChangedInStockQuantity?.call(
                              inStockQuantityListenable.value.toString(),
                            );
                            context.pop();

                          },
                          text: "Save",
                        ),
                        20.h.verticalSpace,
                        AppButton(
                          colorType: AppButtonColorType.secondary,
                          onPressed: () {
                            inStockQuantityListenable.value = oldQty;
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

  _buildLeftSwipeActions(Product product) => ActionPane(
        motion: const ScrollMotion(),
        extentRatio: .75,
        children: [
          AppSlidableaction(
            icon: AppAssets.inventoryHigh,
            labelText: InventoryType.high.toStr(),
            onTap: () {
              widget.onInventoryChange?.call(InventoryType.high);
              _slideController.close();
            },
          ),
          AppSlidableaction(
            icon: AppAssets.inventoryMid,
            labelText: InventoryType.medium.toStr(),
            onTap: () {
              widget.onInventoryChange?.call(InventoryType.medium);
              _slideController.close();
            },
          ),
          AppSlidableaction(
            icon: AppAssets.inventoryLow,
            labelText: InventoryType.low.toStr(),
            onTap: () {
              widget.onInventoryChange?.call(InventoryType.low);
              _slideController.close();
            },
          ),
        ],
      );

  _showDeleteSheet(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you sure want to delete from inventory?',
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
// import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
// import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
// import 'package:shopease_app_flutter/utils/app_assets.dart';
// import 'package:shopease_app_flutter/utils/app_colors.dart';
// import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
// import 'package:shopease_app_flutter/utils/styles.dart';
// class ProductTile extends StatefulWidget {
//   const ProductTile({
//     super.key,
//     required this.product,
//     this.onTap,
//     this.onDelete,
//     this.onInventoryChange,
//     this.onAddToCart, required Null Function() onLongPress,
//   });
//   final Map<dynamic, dynamic> product;
//   final VoidCallback? onTap;
//   final VoidCallback? onDelete;
//   final VoidCallback? onAddToCart;
//   final Function(InventoryType type)? onInventoryChange;
//   @override
//   State<ProductTile> createState() => _ProductTileState();
// }
// class _ProductTileState extends State<ProductTile>
//     with SingleTickerProviderStateMixin {
//   late SlidableController _slideController;
//   @override
//   void initState() {
//     super.initState();
//     _slideController = SlidableController(this);
//   }
//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//     return Slidable(
//       controller: _slideController,
//       endActionPane: _buildRightSwipeActions(product),
//       startActionPane: _buildLeftSwipeActions(product),
//       // controller: _slidableController,
//       child: ListTile(
//         contentPadding: EdgeInsets.zero,
//         onTap: widget.onTap,
//         title: Container(
//           color: Colors.grey[800]!.withOpacity(0.05),
//           width: double.infinity,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(width: 8),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   height: 100.h,
//                   width: 100.h,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(product['image'] ?? ''),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                   width: 8), // Assuming 8.horizontalSpace is a SizedBox
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   Text(
//                     product['title'] ?? '',
//                     style: textStyle16.copyWith(
//                         fontSize: 18, overflow: TextOverflow.ellipsis),
//                   ),
//                   SizedBox(height: 10.h),
//                   AppChip(
//                       text: product['brand'] ??
//                           '') // Assuming 20.verticalSpace is a SizedBox
//                 ],
//               ),
//               const Spacer(),
//               if (product['isInCart'])
//                 SvgIcon(
//                   AppAssets.succcessCart,
//                   size: 25.sp,
//                   color: AppColors.greenColor,
//                 ),
//               SizedBox(width: 25.sp),
//               SvgPicture.asset(
//                 product['inventoryLevel'] == InventoryType.high
//                     ? AppAssets.inventoryHigh
//                     : product['inventoryLevel'] == InventoryType.medium
//                         ? AppAssets.inventoryMid
//                         : AppAssets.inventoryLow,
//                 width: 18.h,
//                 height: 18.h,
//               ),
//               SizedBox(
//                   width: 10.sp), // Assuming 10.horizontalSpace is a SizedBox
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   _buildRightSwipeActions(Map<dynamic, dynamic> product) => ActionPane(
//         motion: const DrawerMotion(),
//         children: [
//           AppSlidableaction(
//             isRight: true,
//             icon: product['isInCart'] ? AppAssets.addtocart : AppAssets.addCart,
//             forgroundColor: AppColors.primaryColor,
//             onTap: () {
//               widget.onAddToCart?.call();
//               _slideController.close();
//             },
//           ),
//           AppSlidableaction(
//             isRight: true,
//             icon: AppAssets.delete,
//             onTap: () {
//               _showDeleteSheet(
//                 product,
//               );
//             },
//             forgroundColor: AppColors.whiteColor,
//             backgroundColor: AppColors.redColor,
//           ),
//         ],
//       );
//   _buildLeftSwipeActions(Map<dynamic, dynamic> product) => ActionPane(
//         motion: const ScrollMotion(),
//         extentRatio: 0.75,
//         children: [
//           AppSlidableaction(
//             icon: AppAssets.inventoryHigh,
//             labelText: InventoryType.high.toStr(),
//             onTap: () {
//               widget.onInventoryChange?.call(InventoryType.high);
//               _slideController.close();
//             },
//           ),
//           AppSlidableaction(
//             icon: AppAssets.inventoryMid,
//             labelText: InventoryType.medium.toStr(),
//             onTap: () {
//               widget.onInventoryChange?.call(InventoryType.medium);
//               _slideController.close();
//             },
//           ),
//           AppSlidableaction(
//             icon: AppAssets.inventoryLow,
//             labelText: InventoryType.low.toStr(),
//             onTap: () {
//               widget.onInventoryChange?.call(InventoryType.low);
//               _slideController.close();
//             },
//           ),
//         ],
//       );
//   _showDeleteSheet(Map<dynamic, dynamic> product) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: EdgeInsets.all(10.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Are you sure want to delete from inventory?',
//               style: textStyle18SemiBold,
//               textAlign: TextAlign.center,
//             ),
//             20.verticalSpace,
//             DeleteButton(
//                 onPressed: () {
//                   widget.onDelete?.call();
//                   _slideController.close();
//                   context.pop();
//                 },
//                 text: 'Delete'),
//             10.verticalSpace,
//             AppButton(
//               onPressed: () {
//                 _slideController.close();
//                 context.pop();
//               },
//               text: 'Cancel',
//               colorType: AppButtonColorType.greyed,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
