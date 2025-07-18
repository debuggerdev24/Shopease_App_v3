import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/history_item_detail_model.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key, required this.history});

  final History history;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<HistoryProvider>()
          .getHistoryItemDetails(histIds: [widget.history.histId]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
          title: provider.isLoading
              ? const SizedBox.shrink()
              : GlobalText(
                  " ${widget.history.itemCount}  Products ",
                  textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
                ),
        ),
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GlobalText(
                          widget.history.updatedDate?.toLocal().toMonthDD ?? '',
                          textStyle: textStyle16.copyWith(
                              fontSize: 14, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      _buildAmountAndShopNameview(),
                      Expanded(
                        child: _buildCurrentListView(provider),
                      ),
                    ]),
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: AppButton(
            text: 'Add to Checklist',
            colorType: provider.isLoading
                ? AppButtonColorType.secondary
                : AppButtonColorType.primary,
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 15.sp),
              child: const SvgIcon(
                AppAssets.checkList,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () async {
              log('calling put checklist from history');
              await provider.putChecklistFromHistory(
                data: [
                  {
                    'hist_id': widget.history.histId,
                  }
                ],
                onSuccess: () {
                  CustomToast.showSuccess(context, 'Items added to checklist!');

                  context.read<ChecklistProvider>().getChecklistItems();
                  context.goNamed(AppRoute.checkList.name);
                },
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }

  Widget _buildCurrentListView(HistoryProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => HistoryItemDetailTile(
        historyItem: provider.historyItemDetails[index],
        onLongPress: () {
          context.goNamed(
            AppRoute.multipleHistoryItemSelection.name,
            extra: widget.history,
          );
        },
      ),
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemCount: provider.historyItemDetails.length,
    );
  }

  Widget _buildAmountAndShopNameview() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlobalText(
            widget.history.shopName,
            maxLine: 3,
            textStyle: textStyle16.copyWith(
                decoration: TextDecoration.underline,
                fontSize: 15,
                decorationColor: AppColors.orangeColor,
                overflow: TextOverflow.ellipsis,
                color: AppColors.orangeColor,
                fontWeight: FontWeight.w600),
          ),
          GlobalText(
            '\$${widget.history.totalPrice}',
            textStyle: textStyle16.copyWith(
                fontSize: 20, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class HistoryItemDetailTile extends StatelessWidget {
  const HistoryItemDetailTile({
    super.key,
    required this.historyItem,
    this.onLongPress,
  });

  final HistoryItemDetail historyItem;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        color: Colors.grey[800]!.withOpacity(0.05),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                    image: CachedNetworkImageProvider(
                        historyItem.imageUrl ?? Constants.placeholdeImg,
                        cacheManager:
                            CachedNetworkImageProvider.defaultCacheManager),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    historyItem.productName!,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle16.copyWith(
                        fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 10.h),
                  if (historyItem.brand.toString().isNotEmpty)
                    AppChip(
                      text: historyItem.brand ?? '',
                    ) // Assuming 20.verticalSpace is a SizedBox
                ],
              ),
            ),
            20.horizontalSpace,
            // SvgPicture.asset(
            //   historyItem.itemLevel == InventoryType.high.name
            //       ? AppAssets.inventoryHigh
            //       : historyItem.itemLevel == InventoryType.medium.name
            //           ? AppAssets.inventoryMid
            //           : AppAssets.inventoryLow,
            //   width: 18.h,
            //   height: 18.h,
            // ),// Assuming 10.horizontalSpace is a SizedBox
          ],
        ),
      ),
    );
  }
}
