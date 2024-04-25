import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_item_manually_form.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({
    super.key,
    this.isEdit = false,
    this.details = const {},
    this.isReplace = false,
  });

  final bool isEdit;
  final bool isReplace;
  final Map<dynamic, dynamic> details;

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
        return AddItemManuallyForm(
          categoties: const [
            'Fresh Fruits',
            'Fresh Vegetables',
            'Other Category'
          ],
          onInventoryLevelChanged: (value) {
            provider.changeAddInvSelectedInvType(value);
          },
          onCategoryChange: (value) {
            provider.changeAddInvSelectedCategory(value.toString());
          },
          onFilePicked: () async {
            return await provider.selectFile();
          },
          onFileClear: provider.clearFile,
          onSubmit: submit,
          isLoading: context.read<InventoryProvider>().isLoading,
        );
      });

  Future<void> submit(Map<String, dynamic> data) async {
    context.read<InventoryProvider>().putInventoryItems(
          data: data,
          onError: (msg) => CustomToast.showError(context, msg),
          onSuccess: () {
            context.read<InventoryProvider>().getInventoryItems();
            context.pop();
          },
        );
  }
}
