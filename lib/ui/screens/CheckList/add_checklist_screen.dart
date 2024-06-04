import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_inventory_form/add_item_form.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';

class AddChecklistScreen extends StatefulWidget {
  const AddChecklistScreen({
    super.key,
    this.isEdit = false,
    this.isFromScan = false,
    this.isReplace = false,
    this.product,
    this.oldChecklistItemId,
  });

  final bool isEdit;
  final bool isReplace;
  final Product? product;
  final bool isFromScan;
  final String? oldChecklistItemId;

  @override
  State<AddChecklistScreen> createState() => _AddChecklistScreenState();
}

class _AddChecklistScreenState extends State<AddChecklistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<ChecklistProvider>(builder: (context, provider, _) {
        return AddItemFormWidget(
          isEdit: widget.isEdit,
          title: widget.isReplace
              ? 'Replace Manually'
              : widget.isEdit
                  ? 'Edit'
                  : 'Add manually',
          isFromReplace: widget.isReplace,
          isFromScan: widget.isFromScan,
          product: widget.product,
          isLoading: provider.isLoading,
          onSubmit: submit,
          oldChecklistItemId: widget.oldChecklistItemId,
        );
      });

  Future<void> submit(Map<String, dynamic> data) async {
    context.read<ChecklistProvider>().putCheklistItems(
      data: [data],
      isEdit: widget.isEdit,
      onError: (msg) => CustomToast.showError(context, msg),
      onSuccess: () {
        if (widget.isReplace) {
          context
              .read<ChecklistProvider>()
              .deleteChecklistItems(itemIds: [widget.oldChecklistItemId!]);
        }
        context.read<ChecklistProvider>().getChecklistItems();
        context.read<NotificationProvider>().getNotifications();
        context.goNamed(AppRoute.checkList.name);
      },
    );
  }
}
