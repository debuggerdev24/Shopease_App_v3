import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_shop_form/add_shop_form.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ShopTile extends StatefulWidget {
  const ShopTile({
    super.key,
    required this.shop,
    this.onTap,
    this.isSelected = false,
    this.isSlideEnabled = true,
    this.omEditTap,
  });

  final Shop shop;
  final VoidCallback? onTap;
  final VoidCallback? omEditTap;
  final bool isSelected;
  final bool isSlideEnabled;

  @override
  State<ShopTile> createState() => _ShopTileState();
}

class _ShopTileState extends State<ShopTile>
    with SingleTickerProviderStateMixin {
  late SlidableController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = SlidableController(this);
  }

  @override
  dispose() {
    super.dispose();
    _slideController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _slideController,
      endActionPane: _buildRightSwipeActions(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
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
                      image: NetworkImage((widget.shop.itemImage == null ||
                              widget.shop.itemImage?.isEmpty == true)
                          ? Constants.placeholdeImg
                          : widget.shop.itemImage ?? ''),
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
                    widget.shop.shopName,
                    maxLines: 10,
                    style: textStyle16.copyWith(
                        fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 10.h),
                  AppChip(text: widget.shop.shopLocation ?? ''),
                ],
              ),
              const Spacer(),

              if (widget.isSelected)
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: const SvgIcon(
                    AppAssets.check,
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRightSwipeActions() => ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.edit,
            forgroundColor: AppColors.primaryColor,
            onTap: widget.omEditTap,
          ),
        ],
      );
}
