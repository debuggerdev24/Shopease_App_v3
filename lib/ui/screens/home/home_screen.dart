import 'dart:developer';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_chip.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/product_tile.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

import '../../widgets/app_txt_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchedProducts = [];
  bool search = false;
  bool searchable = true;

  void _onSearchChanged(String query) {
    final products = context.read<InventoryProvider>().products;
    setState(() {
      if (query.isEmpty) {
        searchedProducts = products;
      } else {
        searchedProducts = products
            .where((product) =>
                product['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      search = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            // toolbarHeight: 150,

            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: searchable
                ? GlobalText(
                    "Inventory List",
                    textStyle: appBarTitleStyle.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 24.sp),
                  )
                : const SizedBox.shrink(),
            actions: [
              searchable
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          searchable = !searchable;
                        });
                        searchController.clear();
                      },
                      icon: SvgIcon(
                        AppAssets.search,
                        size: 20.sp,
                        color: AppColors.blackGreyColor,
                      ))
                  : Stack(
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
                                  setState(() {
                                    searchable = !searchable;
                                  });
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
                                _onSearchChanged(searchController.text);
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
                                  setState(() {
                                    searchable = !searchable;
                                  });
                                },
                                child: const Center(
                                    child: SvgIcon(
                                  AppAssets.cancel,
                                  size: 18,
                                )))),
                      ],
                    ),
              searchable
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: AppIconButton(
                          onTap: () {
                            context.pushNamed(AppRoute.scanAndAddScreen.name,
                                extra: {
                                  'isReplace': false,
                                  'isInvoice': false
                                });
                          },
                          child: const SvgIcon(
                            AppAssets.scanner,
                            size: 23,
                            color: AppColors.blackGreyColor,
                          )),
                    )
                  : Container(),
              searchable
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: AppIconButton(
                          onTap: () {
                            context.pushNamed(
                              AppRoute.addinventoryForm.name,
                              extra: {
                                'isEdit': false,
                                'isReplace': false,
                              },
                            );
                          },
                          child: const SvgIcon(
                            AppAssets.add,
                            size: 20,
                            color: AppColors.orangeColor,
                          )),
                    )
                  : Container(),
            ],
          ),
          body: provider.products.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Row(
                          children: [
                            10.horizontalSpace,
                            Text(
                              '${provider.products.length} Products',
                              style: textStyle16.copyWith(fontSize: 18),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: showFilterSheet,
                              child: SvgPicture.asset(
                                AppAssets.selectedFilterIcon,
                                width: 22.h,
                                height: 22.h,
                              ),
                            ),
                            8.w.horizontalSpace,
                          ],
                        ),
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          itemCount: search
                              ? searchedProducts.length
                              : provider.products.length,
                          separatorBuilder: (context, index) =>
                              10.h.verticalSpace,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductTile(
                              product: provider.products[index],
                             
                              onAddToCart: () {
                                bool value =
                                    provider.products[index]['isInCart'];

                                value = !value;

                                provider.addtoCart(
                                    provider.products[index]['title'],
                                    value,
                                    context);
                              },
                              onTap: () {
                                context.pushNamed(AppRoute.productDetail.name,
                                    extra: provider.products[index]);
                              },
                              onDelete: () {
                                provider.deleteProduct(
                                    provider.products[index]['title'], context);
                              },
                              onInventoryChange: (newType) {
                                provider.changeInventoryType(
                                    provider.products[index]['title'],
                                    newType,
                                    context);
                              },
                            );
                          }),
                    ],
                  ),
                )
              : BounceInUp(
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
                      50.h.verticalSpace,
                      GlobalText(
                        'No matching search results',
                        textStyle: textStyle16.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackGreyColor),
                      ),
                      10.h.verticalSpace,
                      GlobalText(
                        'Add your First Inventory',
                        textStyle: textStyle16.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackGreyColor),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(20.sp),
                        child: AppButton(
                            onPressed: () {
                              context.pushNamed(AppRoute.home.name);
                            },
                            text: 'Add an Inventory'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget buildInventoryContainer(String text, String level) {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(level),
          10.horizontalSpace,
          Text(
            text,
            style: textStyle14.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchedProducts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> product = searchedProducts[index];
        return ListTile(
          title: Text(product['title'] ?? ''),
          subtitle: Text(product['brand'] ?? ''),
          onTap: () {
            // Handle tap on search result
            // context.pushNamed(AppRoute.productDetail.name, extra: product);
          },
        );
      },
    );
  }

  showFilterSheet() async {
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
              child: Column(
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
                  const Wrap(
                    direction: Axis.horizontal,
                    children: [
                      AppChip(text: 'Fresh Fruits'),
                      AppChip(text: 'Category', isSelected: true),
                      AppChip(text: 'Fresh Vegetables'),
                      AppChip(text: 'Other Category'),
                    ],
                  ),
                  10.h.verticalSpace,
                  GlobalText(
                    'Filter by Inventory Level',
                    textStyle: textStyle16.copyWith(fontSize: 15.sp),
                  ),
                  10.h.verticalSpace,
                  Wrap(
                    children: [
                      buildInventoryContainer('High', AppAssets.inventoryHigh),
                      buildInventoryContainer('Medium', AppAssets.inventoryMid),
                      buildInventoryContainer('Low', AppAssets.inventoryLow),
                    ],
                  ),
                  50.h.verticalSpace,
                  AppButton(
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
          );
        });
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<String> productList;

  ProductSearchDelegate(this.productList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = productList
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = productList
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
