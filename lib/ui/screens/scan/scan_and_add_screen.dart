import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/scan_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

import '../../../utils/routes/routes.dart';

class ScanAndAddScreen extends StatefulWidget {
  const ScanAndAddScreen({
    super.key,
    this.isReplace = false,
    this.isInvoice = false,
    this.isFromChecklist = false,
  });
  final bool isReplace;
  final bool isInvoice;
  final bool isFromChecklist;
  @override
  State<ScanAndAddScreen> createState() => _ScanAndAddScreenState();
}

class _ScanAndAddScreenState extends State<ScanAndAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isInvoice
              ? 'Scan & Add Invoice'
              : widget.isReplace
                  ? "Scan & Replace"
                  : "Scan & Add",
          style: textStyle20SemiBold.copyWith(fontSize: 24),
        ),
      ),
      body: Center(child: _buildinventorylist()),
    );
  }

  Widget _buildinventorylist() {
    return Column(
      children: [
        Expanded(
          child: Image.asset(AppAssets.scanner1),
        ),
        AppButton(
          type: AppButtonWidthType.full,
          onPressed: () {
            context.read<ScannerProvider>().initMobileController();
            context.pushNamed(
              AppRoute.scanScreen.name,
              extra: {
                'isInvoice': widget.isInvoice,
                'isReplace': widget.isReplace,
                'isFromChecklist': widget.isFromChecklist,
              },
            );
          },
          text: "Scan Now",
        ),
        15.h.verticalSpace,
        if (widget.isReplace)
          AppButton(
            type: AppButtonWidthType.full,
            onPressed: () {
              context.read<ScannerProvider>().initMobileController();
              context.pushNamed(AppRoute.replaceManually.name);
            },
            text: "Replace Manually",
            colorType: AppButtonColorType.secondary,
          ),
        50.h.verticalSpace,
      ],
    );
  }
}
