import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/no_search_found.dart';
import 'package:shopease_app_flutter/ui/widgets/product_tile.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ChecklistSearchDelegate extends SearchDelegate {
  final List<Product> productList;

  ChecklistSearchDelegate(this.productList);

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
    final List<Product> searchResults = productList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestionList = productList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), suggestionList);
  }

  _buildResultView(ChecklistProvider provider, List<Product> products) {
    return products.isEmpty
        ? const NoSearchFound()
        : ListView.separated(
            itemCount: products.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemBuilder: (context, index) {
              return ProductTile(
                product: products[index],
                isSlideEnabled: false,
                onTap: () {
                  context.pushNamed(AppRoute.productDetail.name, extra: {
                    'product': products[index],
                    'isFromChecklist': true,
                  });
                },
                /*onAddToCart: () {
                  context.read<ChecklistProvider>().putCheklistItems(
                    data: [
                      products[index].copyWith(isInChecklist: true).toJson()
                    ],
                    isEdit: true,
                    onSuccess: () {
                      provider
                          .addToChecklist([products[index]], context, false);
                    },
                  );
                },
                onDelete: () {
                  provider.deletInventoryItems(
                      itemIds: [products[index].itemId],
                      onSuccess: () {
                        provider.getInventoryItems();
                        CustomToast.showSuccess(
                            context, 'Successfully deleted');
                      });
                },
                onInventoryChange: (newType) {
                  provider.changeInventoryType(
                    products[index].itemId,
                    newType,
                  );
                },*/
              );
            },
          );
  }
}
