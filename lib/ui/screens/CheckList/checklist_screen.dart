import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/screens/CheckList/multiple_checklist_selection_screen.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/checklist_search_delegate.dart';
import 'package:shopease_app_flutter/ui/screens/checkList/history_search_delegate.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/checklist_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/date_picker.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/history_list_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/multiple_product_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
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
  bool checklist = false;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _tabsController = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          context
              .read<ChecklistProvider>()
              .changeTab((_tabsController.animation?.value.round() ?? 0));
        },
      );
    // _tabsController.animateTo(context.read<ChecklistProvider>().currentTab);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChecklistProvider>().getChecklistItems();
      context.read<HistoryProvider>().getHistoryItems();
    });
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
                ),
              ),
              Tab(
                child: Text(
                  'History',
                  style: textStyle20SemiBold,
                ),
              ),
            ],
            onTap: provider.changeTab,
          ),
        ),
        body: TabBarView(
          controller: _tabsController,
          children: [
            _buildCurrentListView(provider),
            _buildHistoryView(),
          ],
        ),
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
              showSearch(
                context: context,
                delegate: HistorySearchDelegate(
                    context.read<HistoryProvider>().filteredHistories),
              );
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
                    InkWell(
                      onTap: () => _showChecklistFilterSheet(context),
                      child: SvgPicture.asset(
                        (provider.selectedCategoryFilters.isEmpty &&
                                provider.selectedItemFilter == null)
                            ? AppAssets.filterIcon
                            : AppAssets.selectedFilterIcon,
                        width: 22.h,
                        height: 22.h,
                      ),
                    ),
                    Text('${provider.filteredChecklist.length} Products'),
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
              provider.filteredChecklist.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          120.h.verticalSpace,
                          Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AppAssets.addInventory)),
                            ),
                          ),
                          10.h.verticalSpace,
                          GlobalText(
                            'Nothing inside checklist.',
                            textStyle: textStyle16.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackGreyColor),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: provider.filteredChecklist.length,
                        separatorBuilder: (context, index) => 10.verticalSpace,
                        itemBuilder: (context, index) {
                          final product = provider.filteredChecklist[index];
                          return ChecklistTile(
                            product: product,
                            onTap: () {
                              context.pushNamed(AppRoute.productDetail.name,
                                  extra: {
                                    'product':
                                        provider.selectedChecklists[index],
                                    'isFromChecklist': true,
                                  });
                            },
                            showCheckbox: true,
                            isSelected: product.isSelectedForComplete,
                            onDelete: () async {
                              await provider.deleteChecklistItems(
                                itemIds: [product.itemId!],
                              );
                            },
                            onSelectionChanges: (value) {
                              provider.addProductToSelected(value, product);
                            },
                          );
                        },
                      ),
                    ),

              // Buy button
              if (provider.filteredChecklist
                  .any((e) => e.isSelectedForComplete))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: AppButton(
                      isLoading: provider.isLoading,
                      onPressed: () async {
                        if (!provider.filteredChecklist
                            .any((e) => e.isSelectedForComplete)) {
                          CustomToast.showWarning(
                              context, 'Please select product first.');
                          return;
                        }

                        if (provider.selectedShop == null) {
                          CustomToast.showWarning(
                              context, 'Please select shop');
                          return;
                        }

                        await provider.putInventoryFromChecklist(
                          itemIds: provider.filteredChecklist
                              .where((e) => e.isSelectedForComplete)
                              .map((e) => e.itemId!)
                              .toList(),
                          onSuccess: () async {
                            CustomToast.showSuccess(context,
                                '${provider.selectedItemsCount} Products purchased.');
                            context.read<HistoryProvider>().getHistoryItems();
                            context.goNamed(
                              AppRoute.uploadInvoice.name,
                            );

                            // context.goNamed(AppRoute.checkList.name);
                          },
                        );
                        // provider.clearSelectedProducts();
                      },
                      text: 'Complete (${provider.selectedItemsCount})'),
                )
            ],
          );
  }

  Widget _buildHistoryView() {
    return SingleChildScrollView(
      child: Consumer<HistoryProvider>(builder: (context, provider, _) {
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
                    onTap: () => _showHistoryFilterSheet(context),
                    child: SvgPicture.asset(
                      provider.fromDate == null
                          ? AppAssets.filterIcon
                          : AppAssets.selectedFilterIcon,
                    ),
                  ),
                  8.w.horizontalSpace,
                ],
              ),
            ),
            provider.filteredHistories.isEmpty
                ? const Center(
                    child: GlobalText('Not have any history.'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => HistorylistTile(
                          product: provider.filteredHistories[index],
                          isFromInvoice: false,
                          onAddToChecklistTap: () {
                            provider.putChecklistFromHistory(
                              data: [
                                {
                                  'hist_id':
                                      provider.filteredHistories[index].histId,
                                }
                              ],
                              onSuccess: () {
                                CustomToast.showSuccess(
                                    context, 'Items added to checklist!');
                                context
                                    .read<ChecklistProvider>()
                                    .getChecklistItems();
                              },
                            );
                          },
                        ),
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    itemCount: provider.filteredHistories.length),
          ],
        );
      }),
    );
  }
}

void _showHistoryFilterSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Consumer<HistoryProvider>(builder: (context, provider, _) {
          return Container(
            width: double.infinity,
            // margin: EdgeInsets.symmetric(vertical: 10.sp),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GlobalText('Filter', textStyle: textStyle18SemiBold),
                  20.h.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            provider.resetToData();
                            provider.setFromDate(
                                await showDefultDatePicker(context));
                          },
                          child: _dateContainer(
                            title: 'From',
                            value: provider.fromDate != null
                                ? provider.fromDate!.toDDMonthYYYY
                                : "Select a date",
                          ),
                        ),
                      ),
                      15.w.horizontalSpace,
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            provider
                                .setToDate(await showDefultDatePicker(context),
                                    onError: (msg) {
                              CustomToast.showWarning(context, msg);
                            });
                          },
                          child: _dateContainer(
                            title: 'To',
                            value: provider.toDate != null
                                ? provider.toDate!.toDDMonthYYYY
                                : "",
                          ),
                        ),
                      ),
                    ],
                  ),
                  30.h.verticalSpace,
                  AppButton(
                    onPressed: () {
                      if (provider.fromDate == null) {
                        CustomToast.showWarning(
                          context,
                          'Please select a valid dates.',
                        );
                        return;
                      }
                      provider.filterHistories();
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
                  20.h.verticalSpace,
                ],
              ),
            ),
          );
        });
      });
}

_showChecklistFilterSheet(BuildContext context) async {
  return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 480.h,
          padding: EdgeInsets.symmetric(horizontal: 13.sp, vertical: 5.sp),
          child: SingleChildScrollView(
            child: Consumer<ChecklistProvider>(builder: (context, provider, _) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        GlobalText('Filters', textStyle: textStyle20SemiBold),
                  ),
                  20.h.verticalSpace,
                  GlobalText(
                    'Filter by category',
                    textStyle: textStyle16.copyWith(fontSize: 15.sp),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: Constants.categories
                        .map(
                          (e) => AppChip(
                            text: e.categoryName,
                            isSelected: provider.selectedCategoryFilters
                                .contains(e.categoryId),
                            onTap: () {
                              provider.changeFilterCategoty(e.categoryId);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  10.h.verticalSpace,
                  GlobalText(
                    'Filter by Items',
                    textStyle: textStyle16.copyWith(fontSize: 15.sp),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: ['Selected', 'Non Selected']
                        .map(
                          (e) => AppChip(
                            text: e,
                            isSelected:
                                provider.selectedItemFilter == e.toLowerCase(),
                            onTap: () {
                              provider.changeFilterItem(e.toLowerCase());
                            },
                          ),
                        )
                        .toList(),
                  ),
                  50.h.verticalSpace,
                  Center(
                    child: AppButton(
                        colorType: AppButtonColorType.primary,
                        onPressed: () {
                          provider.filterChecklist();
                          context.pop();
                        },
                        text: 'Apply'),
                  ),
                  10.h.verticalSpace,
                  Center(
                    child: AppButton(
                        colorType: AppButtonColorType.greyed,
                        onPressed: () {
                          context.pop();
                        },
                        text: 'Cancel'),
                  ),
                ],
              );
            }),
          ),
        );
      });
}

Widget _dateContainer({required String title, required String value}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withAlpha(50),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SvgIcon(
          AppAssets.calender,
          color: AppColors.blackColor,
          size: 30,
        ),
        10.w.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                title,
                textStyle: textStyle12.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GlobalText(
                      value,
                      maxLine: 1,
                      textStyle: textStyle12,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 15.w,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
