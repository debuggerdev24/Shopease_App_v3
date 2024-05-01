import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class HistorylistTile extends StatefulWidget {
  const HistorylistTile({
    super.key,
    required this.product,
    this.onDelete,
    this.onChangeBrand,
    this.isFromInvoice = true,
  });

  final History product;
  final bool isFromInvoice;
  final VoidCallback? onDelete;
  final VoidCallback? onChangeBrand;
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
            widget.isFromInvoice == false
                ? context.pushNamed(
                    AppRoute.historyDetail.name,
                    extra: widget.product,
                  )
                : context.pushNamed(AppRoute.saveInvoice.name, extra: {
                    'shop': widget.product.shopName,
                    'total': widget.product.totalPrice
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 70.h,
                    width: 70.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.product.imageUrl ?? Constants.placeholdeImg,
                        ),
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
                        if (widget.isFromInvoice) {
                          context.pushNamed(AppRoute.saveInvoice.name, extra: {
                            'shop': widget.product.shopName,
                            'total': widget.product.totalPrice
                          });
                        }
                      },
                      child: Text(
                        '${widget.product.itemCount ?? 0} products',
                        style: textStyle16.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                const Spacer(), // Assuming 8.horizontalSpace is a SizedBox
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
                      widget.product.shopName,
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

  _buildRightSwipeActions(History history) => ActionPane(
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
                'count': widget.product.itemCount
              });
            },
          ),
        ],
      );
}
