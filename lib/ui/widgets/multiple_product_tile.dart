import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
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
    required this.isSelected,
    this.onInventoryChange,
    this.onLongPress,
     this.showCheckbox = false,
    this.onSelectionChanges,
  });

  final Product product;
  final VoidCallback? onLongPress;
  final Function(bool?)? onSelectionChanges;
  final Function(InventoryType type)? onInventoryChange;
  final bool isSelected;
   final bool showCheckbox;

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
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,

      tileColor: widget.isSelected
          ? Colors.grey[700]!.withOpacity(0.05)
          : Colors.grey.withOpacity(0.2),
      activeColor: AppColors.primaryColor,
      checkColor: AppColors.lightGreenColor,
      contentPadding: const EdgeInsets.only(
        left: 10,
      ),
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Container(
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
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.product.productName!,
                    maxLines: 5,
                    style: textStyle16.copyWith(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                  : widget.product.itemLevel == InventoryType.medium.name
                      ? AppAssets.inventoryMid
                      : AppAssets.inventoryLow,
              width: 18.h,
              height: 18.h,
            ),
            SizedBox(width: 10.sp),
          ],
        ),
      ),
      value: widget.isSelected,
      onChanged: widget.onSelectionChanges,
    );
  }
}
