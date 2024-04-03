import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class HistorylistTile extends StatefulWidget {
  const HistorylistTile(
      {super.key,
      required this.product,
      this.onDelete,
      this.onChangeBrand,
      required this.isUpload});

  final Map<String, dynamic> product;
  final VoidCallback? onDelete;
  final VoidCallback? onChangeBrand;
  final bool isUpload;
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
      endActionPane: _buildRightSwipeActions(widget.product),
      child: ListTile(
          onTap: () {
            widget.product['isInvoice'] == false
                ? context.pushNamed(AppRoute.historyDetail.name, extra: {
                    'invoice': widget.product,
                    'count': widget.product['products']
                  })
                : context.pushNamed(AppRoute.saveInvoice.name, extra: {
                    'shop': widget.product['shop'],
                    'total': widget.product['total']
                  });
            ;
          },
          contentPadding: EdgeInsets.zero,
          title: Container(
            color: Colors.grey[800]!.withOpacity(0.05),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                if (widget.product['img'] == AppAssets.addInvoice)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 70.h,
                      width: 70.h,
                      decoration: BoxDecoration(color: AppColors.whiteColor),
                      child: Image.asset(
                        widget.product['img'] ?? '',
                        alignment: Alignment.center,
                        height: 40.h,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 70.h,
                      width: 70.h,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        image: DecorationImage(
                          image: AssetImage(widget.product['img'] ?? ''),
                          fit: BoxFit.fill,
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
                    GestureDetector(
                      onTap: () {
                        if (widget.product['isInvoice'])
                          context.pushNamed(AppRoute.saveInvoice.name, extra: {
                            'shop': widget.product['shop'],
                            'total': widget.product['total']
                          });
                      },
                      child: Text(
                        '${widget.product['products'] ?? ''} products ',
                        style: textStyle16.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (widget.product['isInvoice'])
                      Text(
                        '\$ ${widget.product['total']}',
                        style: textStyle16.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                      ),
                    SizedBox(),
                  ],
                ),
                Spacer(), // Assuming 8.horizontalSpace is a SizedBox
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    GlobalText(
                      'today',
                      textStyle: textStyle16.copyWith(
                          fontSize: 12, overflow: TextOverflow.ellipsis),
                    ),
                    GlobalText(
                      widget.product['shop'],
                      maxLine: 3,
                      textStyle: textStyle16.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
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

  _buildRightSwipeActions(Map<String, dynamic> product) => ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.addToCheck,
            forgroundColor: AppColors.primaryColor,
            onTap: () {
              context.pushNamed(AppRoute.historyDetail.name, extra: {
                'invoice': widget.product,
                'count': widget.product['products']
              });
            },
          ),
        ],
      );

  _showReplaceBrandSheet(Map<String, dynamic> product) {
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

  _showDeleteSheet(Map<String, dynamic> product) {
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
