import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_item_manually_form.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

class AddChecklistScreen extends StatefulWidget {
  const AddChecklistScreen({
    super.key,
    this.isEdit = false,
    this.product,
  });

  final bool isEdit;
  final Product? product;

  @override
  State<AddChecklistScreen> createState() => _AddChecklistScreenState();
}

class _AddChecklistScreenState extends State<AddChecklistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryProvider>().clearUploadedFilePath();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<ChecklistProvider>(builder: (context, provider, _) {
        return AddItemManuallyForm(
          isEdit: widget.isEdit,
          product: widget.product,
          categoties: const [
            'Fresh Fruits',
            'Fresh Vegetables',
            'Other Category'
          ],
          onFilePicked: () async {
            return await provider.selectFile();
          },
          onFileClear: provider.clearFile,
          isLoading: provider.isLoading,
          onSubmit: submit,
        );
      });

  Future<void> submit(Map<String, dynamic> data) async {
    context.read<ChecklistProvider>().putCheklistItems(
      data: [data],
      isEdit: widget.isEdit,
      onError: (msg) => CustomToast.showError(context, msg),
      onSuccess: () {
        context.read<ChecklistProvider>().getChecklistItems();
        context.goNamed(AppRoute.checkList.name);
      },
    );
  }
}
