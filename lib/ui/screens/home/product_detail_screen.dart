import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
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

  final Product product;

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
                        image: NetworkImage(widget.product.itemImage ??
                            Constants.placeholdeImg),
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
                        widget.product.productName!,
                        textStyle:
                            textStyle18SemiBold.copyWith(fontSize: 19.sp),
                      ),
                      const Spacer(),
                      widget.product.isInChecklist!
                          ? SvgIcon(
                              AppAssets.succcessCart,
                              color: AppColors.greenColor,
                              size: 20.sp,
                            )
                          : const SizedBox.shrink(),
                      15.w.horizontalSpace,
                      SvgPicture.asset(
                        widget.product.itemLevel == InventoryType.high.name
                            ? AppAssets.inventoryHigh
                            : widget.product.itemLevel ==
                                    InventoryType.medium.name
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
                  widget.product.productDescription.toString(),
                  textStyle: textStyle16.copyWith(
                      fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
              ),
              15.verticalSpace,
              Wrap(
                children: [
                  10.horizontalSpace,
                  AppChip(text: widget.product.brand.toString()),
                  // buildCustomContainer(widget.product!['brand'] ?? ''),
                  10.horizontalSpace,
                  AppChip(text: widget.product.itemCategory!),
                  10.horizontalSpace,
                  if (widget.product.itemStorage != null)
                    AppChip(text: widget.product.itemStorage ?? ''),
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
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        child: AppButton(
            colorType: widget.product.isInChecklist == true
                ? AppButtonColorType.secondary
                : AppButtonColorType.primary,
            icon: widget.product.isInChecklist == true
                ? const SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 15.sp),
                    child: const SvgIcon(
                      AppAssets.checkList,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            onPressed: () {
              context
                  .read<ChecklistProvider>()
                  .putChecklistFromInventory(data: [widget.product.itemId!]);
              context.goNamed(AppRoute.home.name);
            },
            text: widget.product.isInChecklist == true
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
