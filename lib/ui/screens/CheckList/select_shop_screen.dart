import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/shop_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/add_shop_form/add_shop_form.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ChecklistProvider>().getShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
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
                    delegate: ShopSearchDelegate(provider.shops),
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
        body: Consumer<ChecklistProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                child: Row(
                  children: [
                    Text('${provider.shops.length} Products'),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          _showFilterSheet(context, provider);
                        },
                        icon: SvgIcon(
                          AppAssets.filterIcon,
                          size: 20.r,
                          color: AppColors.blackColor,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.shops.isEmpty
                        ? Center(
                            child: GlobalText(
                              'You haven\'y added any shop yet.',
                              textStyle: textStyle16,
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.shops.length,
                            itemBuilder: (context, index) {
                              return ShopTile(
                                shop: provider.shops[index],
                                isSelected: provider.selectedShopIndex == index,
                                onTap: () {
                                  provider.changeSelectedShop(index);
                                },
                              );
                            }),
              )
            ],
          );
        }),
      );
    });
  }

  _showAddShopSheet(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => Consumer<ChecklistProvider>(
        builder: (context, provider, _) {
          return AddShopFormWidget(onSubmit: submit);
        },
      ),
    );
  }

  Future<void> submit(Map<String, dynamic> data) async {
    context.read<ChecklistProvider>().putShops(
      data: [data],
      isEdit: false,
      onError: (msg) => CustomToast.showError(context, msg),
      onSuccess: () {
        context.read<ChecklistProvider>().getShops();
        context.pop();
      },
    );
  }

  void _showFilterSheet(
      BuildContext context, ChecklistProvider checklistProvider) {
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
            child: BounceInUp(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GlobalText('Filter', textStyle: textStyle18SemiBold),
                  20.h.verticalSpace,
                  Column(
                    children: checklistProvider.valueList
                        .asMap()
                        .entries
                        .map((entry) {
                      final int index = entry.key;
                      final Map<String, String> filter = entry.value;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            checklistProvider.changeSelectedValue(index);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              checklistProvider.selectedValueIndex == index
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.sp,
                                        vertical: 1.sp,
                                      ),
                                      child: const SvgIcon(
                                        AppAssets.check,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : SizedBox(width: 20.sp),
                              2.horizontalSpace, // Adjust the width as needed
                              GlobalText(
                                filter['name'].toString(),
                                fontSize: 15.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  30.h.verticalSpace,
                  AppButton(
                      colorType: checklistProvider.selectedValueIndex == -1
                          ? AppButtonColorType.secondary
                          : AppButtonColorType.primary,
                      onPressed: () {
                        context.pop();
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
              ),
            ),
          ),
        );
      },
    );
  }
}
