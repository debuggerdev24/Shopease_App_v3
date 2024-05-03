import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/history_list_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/no_search_found.dart';

class HistorySearchDelegate extends SearchDelegate {
  final List<History> productList;

  HistorySearchDelegate(this.productList);

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
    final List<History> searchResults = productList
        .where((product) =>
            product.shopName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<History> suggestionList = productList
        .where((product) =>
            product.shopName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildResultView(context.read<ChecklistProvider>(), suggestionList);
  }

  _buildResultView(ChecklistProvider provider, List<History> products) {
    return products.isEmpty
        ? const NoSearchFound()
        : ListView.separated(
            itemCount: products.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemBuilder: (context, index) {
              return HistorylistTile(
                product: products[index],
                isFromInvoice: false,
                onAddToChecklistTap: () {},
              );
            },
          );
  }
}
