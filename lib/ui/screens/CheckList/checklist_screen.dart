import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/checklist_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
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
      context.read<ChecklistProvider>().getHistoryItems();
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
          title: Text(
            "Check List",
            style: appBarTitleStyle.copyWith(
                fontWeight: FontWeight.w600, fontSize: 24.sp),
          ),
          actions: _buildActions(provider),
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

  List<Widget> _buildActions(ChecklistProvider provider) => [
        IconButton(
          onPressed: () {
            if (provider.currentTab == 0) {
              showSearch(
                context: context,
                delegate: ChecklistSearchDelegate(provider.checklist),
              );
            } else {
              /// Show history search delegate here.
            }
          },
          icon: const SvgIcon(
            AppAssets.search,
            size: 24,
            color: AppColors.blackGreyColor,
          ),
        ),
        if (provider.currentTab == 0) ...[
          AppIconButton(
            onTap: () {
              context.pushNamed(
                AppRoute.scanAndAddScreen.name,
                extra: {'isFromChecklist': true},
              );
            },
            child: const SvgIcon(
              AppAssets.scanner,
              size: 23,
              color: AppColors.blackGreyColor,
            ),
          ),
          AppIconButton(
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
            ),
          ),
        ],
      ];

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
                      child: Text(
                        provider.selectedShop == null
                            ? 'Select shop'
                            : provider.selectedShop!.shopName,
                      ),
                    )
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
                      child: ListView.separated(
                          itemCount: provider.checklist.length,
                          separatorBuilder: (context, index) => 10.verticalSpace,
                          itemBuilder: (context, index) => ChecklistTile(
                                product: provider.checklist[index],
                                onDelete: () async {
                                  await provider.deleteChecklistItems(data: [
                                    provider.checklist[index].itemId!
                                  ]);
                                },
                              )),
                    ),
              // Buy button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: AppButton(
                    onPressed: () {
                      if (provider.selectedShop == null) {
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
                '${provider.histories.length} Items',
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showFilterSheet(context, provider),
                child: SvgPicture.asset(AppAssets.filterIcon),
              ),
              8.w.horizontalSpace,
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: provider.histories
                .map(
                  (e) => HistorylistTile(
                    product: e,
                    isFromInvoice: false,
                    onDelete: () {
                      provider.deleteHistory(e.histId);
                    },
                  ),
                )
                .toList(),
          ),
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
