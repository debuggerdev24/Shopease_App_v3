import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

import '../../utils/enums/expiry_status.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget(
      {super.key, required this.product, this.height, this.width, this.fit});

  final Product product;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100.h,
      width: width ?? double.infinity,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: product.expiryStatus.color),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            product.itemImage ?? Constants.placeholdeImg,
          ),
          fit: fit ?? BoxFit.cover,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ColoredBox(
          color: product.expiryStatus.color,
          child: Text(
            "${product.expiryStatus.displayText} ${(product.expiryStatus == ExpiryStatus.expiring) ? "in ${(product.expiryDate!.difference(DateTime.now()).inDays + 1)} D.." : ""}",
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
