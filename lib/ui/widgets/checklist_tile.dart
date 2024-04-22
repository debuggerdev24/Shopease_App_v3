import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ChecklistTile extends StatefulWidget {
  const ChecklistTile(
      {super.key,
      required this.product,
      this.onDelete,
      this.onChangeBrand,
      required this.isUpload});

  final Map<dynamic, dynamic> product;
  final VoidCallback? onDelete;
  final VoidCallback? onChangeBrand;
  final bool isUpload;
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
  Widget build(BuildContext context) {
    return Slidable(
      controller: _slideController,
      endActionPane:
          widget.isUpload ? null : _buildRightSwipeActions(widget.product),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Container(
          color: Colors.grey[800]!.withOpacity(0.05),
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
                      image: AssetImage(widget.product['image'] ?? ''),
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
                    widget.product['title'] ?? '',
                    style: textStyle16.copyWith(
                        fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 10.h),
                  AppChip(
                      text: widget.product['brand'] ??
                          '') // Assuming 20.verticalSpace is a SizedBox
                ],
              ),
              const Spacer(),
              if (!widget.product['isInCart'])
                SvgIcon(
                  AppAssets.addCart,
                  size: 25.sp,
                  color: AppColors.greenColor,
                ),
              SizedBox(width: 25.sp),
              SvgPicture.asset(
                widget.product['inventoryLevel'] == InventoryType.high
                    ? AppAssets.inventoryHigh
                    : widget.product['inventoryLevel'] == InventoryType.medium
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

  _buildRightSwipeActions(Map<dynamic, dynamic> product) => ActionPane(
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

  _showReplaceBrandSheet(Map<dynamic, dynamic> product) {
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
                        widget.onChangeBrand?.call();
                        _slideController.close();
                        context.pushNamed(AppRoute.scanAndAddScreen.name,
                            extra: {'isReplace': true, 'isInvoice': false});
                      },
                      colorType: AppButtonColorType.primary,
                      text: 'Scan And Replace'),
                  10.verticalSpace,
                  AppButton(
                    onPressed: () {
                      context.pushNamed(AppRoute.replaceManually.name);
                    },
                    text: 'Replace Manually',
                    colorType: AppButtonColorType.secondary,
                  ),
                ],
              ),
            ));
  }

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
              'Are you sure want to delete from Checklist?',
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
