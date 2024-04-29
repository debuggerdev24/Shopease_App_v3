import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/checklist_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/history_list_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/styles.dart';
import '../../widgets/app_icon_button.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabsController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabsController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChecklistProvider>().getChecklistItems();
    });
  }

  void _handleTabChange(int newIndex) {
    final checklistProvider =
        Provider.of<ChecklistProvider>(context, listen: false);
    checklistProvider.changeTab(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
      log('${provider.currentTab}');
      return Scaffold(
        appBar: AppBar(
          title: provider.searchable
              ? const SizedBox.shrink()
              : Text(
                  "Check List",
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
                          hintText: 'Search Product',
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
                        ),
                      ),
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
                ? const SizedBox.shrink()
                : provider.currentTab == 0
                    ? AppIconButton(
                        onTap: () {
                          context
                              .goNamed(AppRoute.scanAndAddScreen.name, extra: {
                            'isInvoice': false,
                            'isReplace': false,
                          });
                        },
                        child: const SvgIcon(
                          AppAssets.scanner,
                          size: 23,
                          color: AppColors.blackGreyColor,
                        ))
                    : const SizedBox.shrink(),
            provider.searchable
                ? const SizedBox.shrink()
                : provider.currentTab == 0
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AppIconButton(
                            onTap: () {
                              context.pushNamed(
                                AppRoute.addChecklistForm.name,
                                extra: {'isEdit': false},
                              );
                            },
                            child: const SvgIcon(
                              AppAssets.add,
                              size: 23,
                              color: AppColors.orangeColor,
                            )),
                      )
                    : const SizedBox.shrink(),
            provider.currentTab != 0
                ? 5.horizontalSpace
                : const SizedBox.shrink(),
          ],
          bottom: TabBar(
            controller: _tabsController,
            indicatorColor: AppColors.orangeColor,
            labelColor: AppColors.orangeColor,
            automaticIndicatorColorAdjustment: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                  child: Text(
                'Current List',
                style: textStyle20SemiBold,
              )),
              Tab(
                  child: Text(
                'History',
                style: textStyle20SemiBold,
              )),
            ],
            onTap: _handleTabChange,
          ),
        ),
        body: TabBarView(controller: _tabsController, children: [
          _buildCurrentListView(provider),
          _buildHistoryView(provider),
        ]),
      );
    });
  }

  Widget _buildCurrentListView(ChecklistProvider provider) {
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Checklist Heading Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    Text('${provider.checklist.length} Products'),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          context.pushNamed(AppRoute.selectShop.name);
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.orangeColor),
                        child: Text(provider.selectedShopIndex < 0
                            ? 'Select shop'
                            : provider.shops[provider.selectedShopIndex]
                                ['title']))
                  ],
                ),
              ),
              // Checklist List view
              provider.checklist.isEmpty
                  ? Center(
                      child: GlobalText(provider.searchable
                          ? 'No matching result found'
                          : 'Nothing inside checklist.'),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: provider.checklist
                              .map(
                                (e) => ChecklistTile(
                                  product: e,
                                  onDelete: () async {
                                    await provider
                                        .putBackToInventory(data: [e.itemId]);
                                  },
                                  isUpload: false,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
              // Buy button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: AppButton(
                    onPressed: () {
                      if (provider.selectedShopIndex < 0) {
                        CustomToast.showWarning(context, 'Please select shop');
                      } else {
                        CustomToast.showSuccess(context,
                            '${provider.checklist.length} Products purchased ');

                        context.goNamed(AppRoute.uploadInvoice.name);
                      }
                    },
                    text: 'Buy products (${provider.checklist.length})'),
              )
            ],
          );
  }

  Widget _buildHistoryView(ChecklistProvider provider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Row(
            children: [
              10.horizontalSpace,
              Text(
                '${provider.historylist.length} Items',
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showFilterSheet(context, provider),
                child: SvgPicture.asset(
                  AppAssets.filterIcon,
                  width: 15.h,
                  height: 15.h,
                ),
              ),
              8.w.horizontalSpace,
            ],
          ),
        ),
        Column(
          children: provider.historylist
              .map(
                (e) => HistorylistTile(
                  product: e,
                  onDelete: () {
                    provider.deleteProduct(e['title']);
                  },
                  isUpload: false,
                ),
              )
              .toList(),
        ),
      ],
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
                    onPressed: () {
                      context.pop();
                    },
                    text: 'Apply',
                  ),
                  10.h.verticalSpace,
                  AppButton(
                    colorType: AppButtonColorType.greyed,
                    onPressed: () {
                      context.pop();
                    },
                    text: 'Cancel',
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
