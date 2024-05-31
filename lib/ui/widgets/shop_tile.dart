import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ShopTile extends StatelessWidget {
  const ShopTile({
    super.key,
    required this.shop,
    this.onTap,
    this.isSelected = false,
  });

  final Shop shop;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    image: NetworkImage((shop.itemImage == null ||
                            shop.itemImage?.isEmpty == true)
                        ? Constants.placeholdeImg
                        : shop.itemImage ?? ''),
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
                  
                  shop.shopName ?? '',
                  maxLines: 10,
                  style: textStyle16.copyWith(
                      fontSize: 18, overflow: TextOverflow.ellipsis),
                ),
                SizedBox(height: 10.h),
                AppChip(
                    text: shop.shopLocation ??
                        '') // Assuming 20.verticalSpace is a SizedBox
              ],
            ),
            const Spacer(),
            if (isSelected)
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
    );
  }
}
