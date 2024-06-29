import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/screens/auth/nick_name_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/shop_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/add_shop_form/add_shop_form.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/shop_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({super.key});

  @override
  State<SelectShopScreen> createState() => _SelectShopScreenState();
}

class _SelectShopScreenState extends State<SelectShopScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // context.read<ChecklistProvider>().clearShopFilter();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ChecklistProvider>().getShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
      log("provider.selectedShopFilter ---0--> ${provider.selectedShopFilter}");
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Shop",
            style: appBarTitleStyle.copyWith(
                fontWeight: FontWeight.w600, fontSize: 24.sp),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ShopSearchDelegate(provider.shops.toList()),
                  );
                },
                icon: const SvgIcon(
                  AppAssets.search,
                  size: 24,
                  color: AppColors.blackGreyColor,
                )),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AppIconButton(
                  onTap: () {
                    _showAddShopSheet(context);
                  },
                  child: const SvgIcon(
                    AppAssets.add,
                    size: 23,
                    color: AppColors.orangeColor,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                children: [
                  10.horizontalSpace,
                  Text(
                    '${provider.filteredShops.length} Shops',
                    style: textStyle16.copyWith(fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showFilterSheet,
                    icon: SvgIcon(
                      // checkfilterValue
                      (!provider.shopvalue)
                          // provider.selectValue
                          ? AppAssets.filterIcon
                          : AppAssets.selectedFilterIcon,
                      size: 25.r,
                      // color: AppColors.blackColor,
                    ),
                  ),
                  8.w.horizontalSpace,
                ],
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.filteredShops.isEmpty
                      ? Center(
                          child: GlobalText(
                            'You haven\'t added any shop yet.',
                            textStyle: textStyle16,
                          ),
                        )
                      : ListView.separated(
                          itemCount: provider.filteredShops.length,
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          itemBuilder: (context, index) {
                            return ShopTile(
                              shop: provider.filteredShops[index],
                              isSelected: provider.selectedShop?.shopId ==
                                  provider.filteredShops[index].shopId,
                              onTap: () {
                                provider.changeSelectedShop(
                                    provider.filteredShops[index].shopId);
                              },
                              omEditTap: () {
                                _showEditShopSheet(
                                    provider.filteredShops[index]);
                              },
                            );
                          },
                        ),
            )
          ],
        ),
      );
    });
  }

  _showAddShopSheet(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AddShopFormWidget(
            onSubmit: (data) {
              submitShopForm(data, false);
            },
            onNameChange: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }

  _showEditShopSheet(Shop shop) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => AddShopFormWidget(
        shop: shop,
        onSubmit: (data) {
          log('data from form: $data');
          submitShopForm(data, true);
        },
      ),
    );
  }

  Future<void> submitShopForm(Map<String, dynamic> data, bool isEdit) async {
    context.read<ChecklistProvider>().putShops(
      data: [data],
      isEdit: isEdit,
      onError: (msg) => CustomToast.showError(context, msg),
      onSuccess: () {
        CustomToast.showSuccess(
            context, 'Shop has been ${isEdit ? 'Edited' : 'Added'}.');
        context.read<ChecklistProvider>().getShops();
        context.pop();
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10.sp),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Consumer<ChecklistProvider>(builder: (context, provider, _) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GlobalText('Filter', textStyle: textStyle18SemiBold),
                  SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      itemCount: provider.shopLoacations.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            provider.changeShopFilter(
                                provider.shopLoacations.toList()[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              // color: AppColors.primaryColor.withOpacity(0.2),
                            ),
                            height: 40.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (provider.selectedShopFilter.contains(
                                    provider.shopLoacations.toList()[index]))
                                  Icon(
                                    CupertinoIcons.checkmark,
                                    color: AppColors.primaryColor,
                                  ),
                                10.horizontalSpace,
                                GlobalText(
                                  textStyle: textStyle16,
                                  provider.shopLoacations.toList()[index],
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  /*Wrap(
                    alignment: WrapAlignment.start,
                    children: provider.shopLoacations.indexed.map((e) {
                      return AppChip(
                        text: e.$2,
                        isSelected: provider.selectedShopFilter.contains(e.$2),
                        onTap: () {
                          provider.changeShopFilter(e.$2);
                        },
                      );
                    }).toList(),
                  ),*/
                  30.h.verticalSpace,
                  AppButton(
                      colorType: AppButtonColorType.primary,
                      onPressed: () {
                        provider.filterShops();
                        context.pop();
                        // setState(() {
                        //   checkfilterValue = !checkfilterValue;
                        // });
                      },
                      text: 'Apply'),
                  10.h.verticalSpace,
                  AppButton(
                      colorType: AppButtonColorType.greyed,
                      onPressed: () {
                        context.pop();
                      },
                      text: 'Cancel'),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
