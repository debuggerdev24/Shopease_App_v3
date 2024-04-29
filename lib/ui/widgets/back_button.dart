import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';

class KBackButton extends StatelessWidget {
  const KBackButton({super.key, this.onBackClick, this.color, this.size});

  final VoidCallback? onBackClick;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (!context.canPop()) {
      return const SizedBox();
    }
    return IconButton(
      onPressed: () {
        onBackClick?.call();
        context.pop();
      },
      icon: SvgIcon(AppAssets.arrowLeft, color: color ?? AppColors.blackColor),
    );
  }
}
