import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/add_item_manually_form.dart';

class AddChecklistScreen extends StatefulWidget {
  const AddChecklistScreen({
    super.key,
  });

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
          categoties: const [
            'Fresh Fruits',
            'Fresh Vegetables',
            'Other Category'
          ],
          onInventoryLevelChanged: (value) {
            provider.changeAddCLSelectedInvType(value);
          },
          onCategoryChange: (value) {
            provider.changeAddCLSelectedCategory(value.toString());
          },
          onFilePicked: () async {
            return await provider.selectFile();
          },
          onFileClear: provider.clearFile,
          onSubmit: submit,
        );
      });

  Future<void> submit(Map<String, dynamic> data) async {
    // context.read<ChecklistProvider>().putInventoryItems(
    //       onError: (msg) => CustomToast.showError(context, msg),
    //       onSuccess: () => context.pushNamed(AppRoute.checkList.name),
    //     );
  }
}
