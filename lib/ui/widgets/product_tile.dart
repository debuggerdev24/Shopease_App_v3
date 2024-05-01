import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
    this.onInventoryChange,
    this.onAddToCart,
    this.onLongPress,
    this.check,
    this.isSlideEnabled = true,
  });

  final Product product;
  final bool? check;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;
  final VoidCallback? onLongPress;
  final bool isSlideEnabled;
  final Function(InventoryType type)? onInventoryChange;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile>
    with SingleTickerProviderStateMixin {
  late SlidableController _slideController;

  @override
  void initState() {
    super.initState();

    _slideController = SlidableController(this);
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
      endActionPane: !widget.isSlideEnabled
          ? null
          : _buildRightSwipeActions(widget.product),
      startActionPane: !widget.isSlideEnabled
          ? null
          : _buildLeftSwipeActions(widget.product),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          color: Colors.grey[800]!.withOpacity(0.05),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.product.itemImage ?? Constants.placeholdeImg,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  width: 8), // Assuming 8.horizontalSpace is a SizedBox
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.product.productName!,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle16.copyWith(
                          fontSize: 18, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: 10.h),
                    AppChip(
                        text: widget.product.brand ??
                            '') // Assuming 20.verticalSpace is a SizedBox
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
    );
  }

  _buildRightSwipeActions(Product product) => ActionPane(
        motion: const DrawerMotion(),
        children: [
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

  _buildLeftSwipeActions(Product product) => ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.75,
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
