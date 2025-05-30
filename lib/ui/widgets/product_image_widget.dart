import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget(
      {super.key, required this.product, this.height, this.width});

  final Product product;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100.h,
      width: width ?? double.infinity,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border.all(color: product.expiryStatus.color),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            product.itemImage ?? Constants.placeholdeImg,
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ColoredBox(
          color: product.expiryStatus.color,
          child: Text(
            product.expiryStatus.displayText,
            textAlign: TextAlign.center,
            style: textStyle12.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
