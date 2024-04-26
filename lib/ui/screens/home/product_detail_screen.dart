import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_icon_button.dart';
import '../../widgets/global_text.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          "Details",
          style: appBarTitleStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 24.sp),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppIconButton(
                onTap: () {
                  context.pushNamed(
                    AppRoute.addinventoryForm.name,
                    extra: {
                      'isEdit': true,
                      'details': widget.product,
                    },
                  );
                },
                child: const SvgIcon(
                  AppAssets.edit,
                  size: 23,
                  color: AppColors.blackGreyColor,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Container(
                  height: 250.h,
                  // width:.
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(
                            color: AppColors.mediumGreyColor.shade200,
                            width: 2.8)),
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage(widget.product['image'] ?? ""),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlobalText(
                        widget.product['title'].toString(),
                        textStyle:
                            textStyle18SemiBold.copyWith(fontSize: 19.sp),
                      ),
                      Spacer(),
                      widget.product['isInCart']
                          ? SvgIcon(
                              AppAssets.succcessCart,
                              color: AppColors.greenColor,
                              size: 20.sp,
                            )
                          : SizedBox(),
                      15.w.horizontalSpace,
                      SvgPicture.asset(
                        widget.product['inventoryLevel'] == InventoryType.high
                            ? AppAssets.inventoryHigh
                            : widget.product['inventoryLevel'] ==
                                    InventoryType.medium
                                ? AppAssets.inventoryMid
                                : AppAssets.inventoryLow,
                        width: 18.h,
                        height: 18.h,
                      ),
                      5.w.horizontalSpace,
                    ],
                  ),
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: GlobalText(
                  widget.product['desc'],
                  textStyle: textStyle16.copyWith(
                      fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
              ),
              15.verticalSpace,
              Wrap(
                children: [
                  10.horizontalSpace,
                  AppChip(text: widget.product['brand']),
                  // buildCustomContainer(widget.product!['brand'] ?? ''),
                  10.horizontalSpace,
                  AppChip(text: widget.product['category']),
                  10.horizontalSpace,
                  AppChip(text: widget.product['storage']),
                ],
              ),
              10.verticalSpace,
              20.verticalSpace,
              // Center(
              //   child: AppButton(
              //       icon: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 4),
              //         child: SvgIcon(
              //           AppAssets.checkList,
              //           color: Colors.white,
              //           size: 20,
              //         ),
              //       ),
              //       onPressed: () {},
              //       text: 'Add to Checklist'),
              // ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        child: AppButton(
            colorType: widget.product['isInCart']
                ? AppButtonColorType.secondary
                : AppButtonColorType.primary,
            icon: widget.product['isInCart']
                ? SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 15.sp),
                    child: SvgIcon(
                      AppAssets.checkList,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            onPressed: () {
              setState(() {
                if (widget.product['isInCart'])
                  widget.product['isInCart'] = !widget.product['isInCart'];
              });
              context.goNamed(AppRoute.home.name);
            },
            text: widget.product['isInCart']
                ? 'Remove from Checklist'
                : 'Add to Checklist'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget buildCustomContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GlobalText(
            text,
            textStyle: textStyle14,
            color: AppColors.primaryColor,
          )),
    );
  }
}
