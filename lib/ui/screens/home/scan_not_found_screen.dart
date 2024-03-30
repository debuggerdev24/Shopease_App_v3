import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ScanNotFoundScreen extends StatelessWidget {
  const ScanNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan & Add',
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgIcon(
                      AppAssets.errorWarning,
                      size: 200.r,
                    ),
                    10.h.verticalSpace,
                    Text('Barcode scan details not found!', style: textStyle16),
                  ],
                ),
              ),
              AppButton(
                onPressed: () {
                  context.pushNamed(
                    AppRoute.addinventoryForm.name,
                    extra: {'isEdit': false, 'isReplace': false,},
                  );
                },
                text: 'Add Manually',
                colorType: AppButtonColorType.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
