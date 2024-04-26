// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MultipleProductTile extends StatefulWidget {
  const MultipleProductTile({
    super.key,
    required this.product,
    this.onInventoryChange,
    this.onLongPress,
    this.onSelectionChanges,
  });

  final Product product;
  final VoidCallback? onLongPress;
  final Function(bool?)? onSelectionChanges;
  final Function(InventoryType type)? onInventoryChange;

  @override
  State<MultipleProductTile> createState() => _MultipleProductTileState();
}

class _MultipleProductTileState extends State<MultipleProductTile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(builder: (context, provider, _) {
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        tileColor: Colors.grey[800]!.withOpacity(0.05),
        activeColor: AppColors.primaryColor,
        checkColor: AppColors.lightGreenColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        title: SizedBox(
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
                          widget.product.itemImage ?? Constants.placeholdeImg),
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
                    widget.product.productName,
                    style: textStyle16.copyWith(
                        fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 10.h),
                  AppChip(
                      text: widget.product.brand ??
                          '') // Assuming 20.verticalSpace is a SizedBox
                ],
              ),
              const Spacer(),
              if (widget.product.isInCart)
                SvgIcon(
                  AppAssets.succcessCart,
                  size: 20.sp,
                  color: AppColors.greenColor,
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
        value: provider.selectedProducts.contains(widget.product),
        onChanged: widget.onSelectionChanges,
      );
    });
  }

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
                  // widget.onDelete?.call();
                  context.pop();
                },
                text: 'Delete'),
            10.verticalSpace,
            AppButton(
              onPressed: () {
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
