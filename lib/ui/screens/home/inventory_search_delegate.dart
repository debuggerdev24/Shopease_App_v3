import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/no_search_found.dart';
import 'package:shopease_app_flutter/ui/widgets/inventory_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Product> productList;

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
    final List<Product> searchResults = productList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestionList = productList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(suggestionList);
  }

  _buildResultView(List<Product> products) {
    return Consumer<InventoryProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const NoSearchFound()
              : ListView.separated(
                  itemCount: products.length,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  separatorBuilder: (context, index) => 10.verticalSpace,
                  itemBuilder: (context, index) {
                    return InventoryTile(
                      product: products[index],
                      isSlideEnabled: true,
                      onTap: () {
                        context.pushNamed(AppRoute.productDetail.name,
                            extra: {'product': products[index]});
                      },
                      onAddToCart: () {
                        if (products[index].isInChecklist == true) {
                          context
                              .read<ChecklistProvider>()
                              .deleteChecklistItems(
                                  itemIds: [products[index].itemId!],
                                  onSuccess: () {
                                    provider.addToChecklist(
                                        [products[index]], context, false);
                                  });
                        } else {
                          context
                              .read<ChecklistProvider>()
                              .putChecklistFromInventory(
                            data: [products[index].itemId!],
                            onSuccess: () {
                              provider.addToChecklist(
                                  [products[index]], context, false);
                            },
                          );
                        }
                      },
                      onDelete: () {
                        provider.deletInventoryItems(
                            itemIds: [products[index].itemId!],
                            onSuccess: () {
                              provider.getInventoryItems();
                              CustomToast.showSuccess(
                                  context, 'Successfully deleted');
                            });
                      },
                      onInventoryChange: (newType) {
                        provider.changeInventoryType(
                          products[index].itemId!,
                          newType,
                        );
                      },
                      onChangedInStockQuantity: (q) {
                        provider.changeInStockQuantity(
                          products[index].itemId!,
                          q,
                        );
                      },
                    );
                  },
                );
    });
  }
}
