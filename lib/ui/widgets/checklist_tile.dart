import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
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
  });

  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSlideEnabled;
  final bool isSelected;
  final Function(bool?)? onSelectionChanges;
  final bool showCheckbox;

  @override
  State<ChecklistTile> createState() => _ChecklistTileState();
}

class _ChecklistTileState extends State<ChecklistTile>
    with SingleTickerProviderStateMixin {
  late final SlidableController _slideController;

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
                ? Colors.grey[200]!.withOpacity(.05)
                : Colors.grey[800]!.withOpacity(0.05),
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
                  child: Container(
                    height: 100.h,
                    width: 100.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.product.itemImage ?? Constants.placeholdeImg,
                        ),
                        fit: BoxFit.contain,
                      ),
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
                SizedBox(width: 10.h),

                /// Saroj - told to remove this icon
                // SvgIcon(
                //   AppAssets.addCart,
                //   size: 25.sp,
                //   color: AppColors.greenColor,
                // ),
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
        motion: const DrawerMotion(),
        children: [
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.replace,
            forgroundColor: AppColors.primaryColor,
            onTap: () {
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
