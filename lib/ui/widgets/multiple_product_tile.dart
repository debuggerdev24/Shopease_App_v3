import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.showCheckbox = true,
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
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        color: widget.isSelected
            ? Colors.grey[700]!.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.2),
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.showCheckbox)
              Transform.scale(
                scale: 1.25,
                child: Checkbox(
                  value: widget.isSelected,
                  onChanged: widget.onSelectionChanges,
                  // activeColor: AppColors.greenColor,
                ),
              ),
            const SizedBox(width: 8),
            Container(
              height: 100.h,
              width: 100.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
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
                    "${widget.product.productName!} (${widget.product.inStockQuantity})",
                    maxLines: 5,
                    style: textStyle16.copyWith(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (widget.product.brand.toString().isNotEmpty)
                    AppChip(text: widget.product.brand ?? ''),
                ],
              ),
            ),
            if (widget.product.isInChecklist == true) ...[
              SizedBox(width: 20.w),
              SvgPicture.asset(
                AppAssets.succcessCart,
                width: 20.sp,
                height: 20.sp,
                color: AppColors.greenColor,
              ),
            ],
            SizedBox(width: 20.w),
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
    );
  }
}
