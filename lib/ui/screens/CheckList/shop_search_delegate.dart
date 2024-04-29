import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ShopSearchDelegate extends SearchDelegate {
  final List<Shop> shopList;

  ShopSearchDelegate(this.shopList);

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Shop> searchResults = shopList
        .where((shop) => shop.shopName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Shop> suggestionList = shopList
        .where((shop) => shop.shopName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), suggestionList);
  }

  _buildResultView(ChecklistProvider provider, List<Shop> shops) {
    return shops.isEmpty
        ? Center(
            child: GlobalText(
              'Not found matching results.',
              textStyle: textStyle16,
            ),
          )
        : ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  provider.changeSelectedShop(index);
                },
                child: Consumer<ChecklistProvider>(
                    builder: (context, provider, _) {
                  return ListTile(
                    title: GlobalText(shops[index].shopName),
                    trailing: (provider.selectedShopIndex == index)
                        ? Padding(
                            padding: EdgeInsets.all(20.h),
                            child: const SvgIcon(
                              AppAssets.check,
                              color: AppColors.primaryColor,
                            ),
                          )
                        : null,
                  );
                }),
              );
            },
          );
  }
}
