import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/Models/product_model.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class HistorylistTile extends StatefulWidget {
  const HistorylistTile({
    super.key,
    required this.onAddToChecklistTap,
    required this.product,
    this.isFromInvoice = true,
    this.isSlideEnabled = true,
  });

  final History product;
  final bool isFromInvoice;
  final VoidCallback onAddToChecklistTap;
  final bool isSlideEnabled;

  @override
  State<HistorylistTile> createState() => _HistorylistTileState();
}

class _HistorylistTileState extends State<HistorylistTile>
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
      endActionPane: _buildRightSwipeActions(
        widget.product,
      ),
      child: GestureDetector(
          onTap: () {
            context.pushNamed(
              AppRoute.historyDetail.name,
              extra: widget.product,
            );
          },
          // 815fc512-1673-43cf-ba6c-a3e3508b402f
          child: Container(
            color: Colors.grey[800]!.withOpacity(0.05),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                      onTap: () {
                        if (widget.product.imageUrl == null ||
                            widget.product.imageUrl?.isEmpty == true) {
                          context.pushNamed(
                            AppRoute.addInvoice.name,
                            extra: {
                              'shop': widget.product.shopName,
                              'histId': widget.product.histId,
                            },
                          );
                        } else {
                          _showImgSheet();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 70.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          image: widget.product.imageUrl == null ||
                                  widget.product.imageUrl!.isEmpty
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(widget.product.imageUrl!),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        child: widget.product.imageUrl == null ||
                                widget.product.imageUrl!.isEmpty
                            ? Image.asset(
                                AppAssets.doitlater,
                                height: 30.h,
                                width: 30.h,
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppAssets.zoomIcon,
                                  height: 30.h,
                                  width: 30.h,
                                ),
                              ),
                      )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '${widget.product.itemCount ?? 0} products',
                        style: textStyle16.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (widget.isFromInvoice)
                        Text(
                          '\$ ${widget.product.totalPrice}',
                          style: textStyle16.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                        ),
                      const SizedBox(),
                    ],
                  ),
                ), // Assuming 8.horizontalSpace is a SizedBox
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10),
                    GlobalText(
                      widget.product.updatedDate?.toMonthDD ?? '',
                      textStyle: textStyle16.copyWith(
                          fontSize: 12, overflow: TextOverflow.ellipsis),
                    ),
                    GlobalText(
                      widget.product.shopName,
                      maxLine: 3,
                      textStyle: textStyle16.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.orangeColor,
                          fontSize: 15,
                          height: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.orangeColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
          )),
    );
  }

  _buildRightSwipeActions(
    History history,
  ) =>
      ActionPane(
        motion: const DrawerMotion(),
        extentRatio: widget.product.imageUrl!.isNotEmpty ? 0.4 : 0.2,
        children: [
          if (widget.product.imageUrl!.isNotEmpty)
            AppSlidableaction(
              isRight: true,
              icon: AppAssets.replace,
              forgroundColor: AppColors.primaryColor,
              onTap: () {
                // _showReplaceBrandSheet();
                // widget.onAddToChecklistTap();
                // _slideController.close();
                context.pushNamed(AppRoute.editInvoice.name,
                                            extra: {
                    'shop': widget.product.shopName,
                    'histId': widget.product.histId,
                  },
                );
             
              

              },
            ),
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.addToCheck,
            forgroundColor: AppColors.primaryColor,
            onTap: () {
              widget.onAddToChecklistTap();
              _slideController.close();
            },
          ),
        ],
      );

  Future<void> _showImgSheet() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10.h),
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: NetworkImage(
                  widget.product.imageUrl ?? Constants.placeholdeImg,
                ),
              ),
            ),
            child: IconButton.filled(
              onPressed: context.pop,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.lightGreyColor,
              ),
              icon: const Icon(Icons.clear),
            ),
          );
        });
  }

  _showReplaceBrandSheet() {
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
                      });
                    },
                    text: 'Replace Manually',
                    colorType: AppButtonColorType.secondary,
                  ),
                ],
              ),
            ));
  }
}
