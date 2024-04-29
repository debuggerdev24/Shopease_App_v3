import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_inventory_form/add_item_form.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({
    super.key,
    this.isEdit = false,
    this.product,
    this.isReplace = false,
  });

  final bool isEdit;
  final bool isReplace;
  final Product? product;

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<InventoryProvider>(builder: (context, provider, _) {
        return AddItemFormWidget(
          isEdit: widget.isEdit,
          product: widget.product,
          onSubmit: submit,
          isLoading: provider.isLoading,
        );
      });

  Future<void> submit(Map<String, dynamic> data) async {
    context.read<InventoryProvider>().putInventoryItem(
          data: [data],
          isEdit: widget.isEdit,
          onError: (msg) => CustomToast.showError(context, msg),
          onSuccess: () {
            context.read<InventoryProvider>().getInventoryItems();
            context.goNamed(AppRoute.home.name);
          },
        );
  }
}
