import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/shop_tile.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Select Shop'),
        //   actions: [
        //     IconButton(
        //         onPressed: () {},
        //         icon: const SvgIcon(
        //           AppAssets.search,
        //           size: 24,
        //           color: AppColors.blackGreyColor,
        //         )),
        //     AppIconButton(
        //         onTap: _showAddShopSheet,
        //         child: const SvgIcon(
        //           AppAssets.add,
        //           size: 23,
        //           color: AppColors.orangeColor,
        //         ))
        //   ],
        // ),

        appBar: AppBar(
          title: provider.searchable
              ? SizedBox()
              : Text(
                  "Select Shop",
                  style: appBarTitleStyle.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 24.sp),
                ),
          actions: [
            provider.searchable
                ? Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                          color: Colors.white,
                          height: 500,
                          width: 370.w,
                          child: AppTextField(
                            hintText: 'Search Shop',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.r),
                              borderSide: const BorderSide(
                                color: AppColors.blackGreyColor,
                              ),
                            ),
                            prefixIcon: AppIconButton(
                              onTap: () {
                                provider.toggleSearchable();
                              },
                              child: searchController.text.isEmpty
                                  ? const Icon(Icons.arrow_back)
                                  : const SvgIcon(
                                      AppAssets.search,
                                      size: 15,
                                    ),
                            ),
                            controller: searchController,
                            onChanged: (value) {
                              log("search text:${searchController.text}");
                            },
                            name: 'Search',
                          )),
                      Positioned(
                          top: 15,
                          right: 40,
                          child: GestureDetector(
                              onTap: () {
                                log('Search clicked!');
                                provider.toggleSearchable();
                              },
                              child: const Center(
                                  child: SvgIcon(
                                AppAssets.cancel,
                                size: 18,
                              )))),
                    ],
                  )
                : IconButton(
                    onPressed: () {
                      provider.toggleSearchable();
                    },
                    icon: const SvgIcon(
                      AppAssets.search,
                      size: 24,
                      color: AppColors.blackGreyColor,
                    )),
            provider.searchable
                ? SizedBox()
                : Padding(
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
                SingleChildScrollView(
                  child: Column(
                    children: provider.shops.indexed
                        .map(
                          (e) => ShopTile(
                            shop: e.$2,
                            onTap: () {
                              provider.changeSelectedShop(e.$1);
                            },
                            isSelected: provider.selectedShopIndex == e.$1,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          );
        }),
      );
    });
  }

  _showAddShopSheet(BuildContext context) {
    final ValueNotifier<bool> isEnabled = ValueNotifier(false);
    late final TextEditingController _nameController;
    TextEditingController? _locationController;

    _nameController = TextEditingController()
      ..addListener(() {
        if (_nameController.text.isNotEmpty) {
          isEnabled.value = true;
        } else {
          isEnabled.value = false;
        }
      });

    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints.loose(Size(double.infinity, 0.6.sh)),
      context: context,
      builder: (context) => Consumer<ChecklistProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                GlobalText('Create New Shop', textStyle: textStyle18SemiBold),
                30.h.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: '*',
                      style: const TextStyle(color: Colors.red, fontSize: 17),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Shop Name',
                          style: textStyle16.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                AppTextField(
                  name: 'name',
                  controller: _nameController,
                ),
                20.h.verticalSpace,
                AppTextField(
                  name: 'location',
                  controller: _locationController,
                  labelText: 'Location',
                ),
                60.h.verticalSpace,
                ValueListenableBuilder<bool>(
                    valueListenable: isEnabled,
                    builder: (context, value, child) {
                      return AppButton(
                        onPressed: () {
                          provider.addToShop(
                            {
                              'img': AppAssets.noImage,
                              'title': _nameController.text,
                              'brand': 'Brand ',
                            },
                          );
                          context.pop();
                        },
                        text: 'Create',
                        colorType: value
                            ? AppButtonColorType.primary
                            : AppButtonColorType.greyed,
                      );
                    }),
                20.h.verticalSpace,
                AppButton(
                  onPressed: () {},
                  text: 'Cancel',
                  colorType: AppButtonColorType.secondary,
                )
              ],
            ),
          );
        },
      ),
    );
  }
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
      });
}
