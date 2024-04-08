import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/screens/auth/nick_name_screen.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MultipleProductTile extends StatefulWidget {
  const MultipleProductTile({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
    this.onInventoryChange,
    this.onAddToCart,
    this.onLongPress,
    this.check,
    required this.context,
  });

  final Map<dynamic, dynamic> product;
  final BuildContext context;
  final bool? check;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;
  final VoidCallback? onLongPress;
  final Function(InventoryType type)? onInventoryChange;

  @override
  State<MultipleProductTile> createState() => _MultipleProductTileState();
}

class _MultipleProductTileState extends State<MultipleProductTile>
    with SingleTickerProviderStateMixin {
  late SlidableController _slideController;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.product['isInCart'];

    _slideController = SlidableController(this);
  }

  @override
  Widget build(BuildContext context) {
    final InventoryProvider inventoryProvider = InventoryProvider();
    final product = widget.product;
    int selectValue = 0;

    void _itemChange(bool? val, BuildContext context) {
      setState(() {
        if (val != null) {
          _isChecked = val;
          product['isInCart'] = val;

          if (val) {
            Provider.of<InventoryProvider>(context, listen: false)
                .addtoCart(product['title'], true, context, false);
          } else {
            Provider.of<InventoryProvider>(context, listen: false)
                .addtoCart(product['title'], false, context, false);
          }
        }
      });
    }

    log("CheckOut--- List :${inventoryProvider.checkOutList.length}");

    int selectedCount = 0;

    return Slidable(
      controller: _slideController,
      // endActionPane: _buildRightSwipeActions(product),
      // startActionPane: _buildLeftSwipeActions(product),
      // // controller: _slidableController,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: Colors.grey[800]!.withOpacity(0.05),
          activeColor: AppColors.primaryColor,
          checkColor: AppColors.lightGreenColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          
          title: Container(
            // color: Colors.grey[800]!.withOpacity(0.05),
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
                        image: AssetImage(product['image'] ?? ''),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8), // Assuming 8.horizontalSpace is a SizedBox
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      product['title'] ?? '',
                      style: textStyle16.copyWith(
                          fontSize: 18, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: 10.h),
                    AppChip(
                        text: product['brand'] ??
                            '') // Assuming 20.verticalSpace is a SizedBox
                  ],
                ),
                const Spacer(),
                if (product['isInCart'])
                  SvgIcon(
                    AppAssets.succcessCart,
                    size: 20.sp,
                    color: AppColors.greenColor,
                  ),
                SizedBox(width: 25.sp),
                SvgPicture.asset(
                  product['inventoryLevel'] == InventoryType.high
                      ? AppAssets.inventoryHigh
                      : product['inventoryLevel'] == InventoryType.medium
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
          value: _isChecked,
          onChanged: (value) => _itemChange(value, context),
        ),
      ),
    );
  }

  _buildRightSwipeActions(Map<dynamic, dynamic> product) => ActionPane(
        motion: const DrawerMotion(),
        children: [
          AppSlidableaction(
            isRight: true,
            height: product['isInCart'] ? 29.sp : 18.sp,
            icon: product['isInCart'] ? AppAssets.rmCart : AppAssets.addCart,
            forgroundColor: AppColors.primaryColor,
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

  _buildLeftSwipeActions(Map<dynamic, dynamic> product) => ActionPane(
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

  _showDeleteSheet(Map<dynamic, dynamic> product) {
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
