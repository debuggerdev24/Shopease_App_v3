import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/no_search_found.dart';
import 'package:shopease_app_flutter/ui/widgets/shop_tile.dart';

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

    return _buildResultView(searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Shop> suggestionList = shopList
        .where((shop) => shop.shopName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildResultView(suggestionList);
  }

  _buildResultView(List<Shop> shops) {
    return shops.isEmpty
        ? const NoSearchFound()
        : ListView.builder(
            itemCount: shops.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              return Consumer<ChecklistProvider>(
                  builder: (context, provider, _) {
                return ShopTile(
                  shop: shops[index],
                  isSelected:
                      provider.selectedShop?.shopId == shops[index].shopId,
                  onTap: () {
                    provider.changeSelectedShop(shops[index].shopId);
                  },
                );
              });
            },
          );
  }
}
