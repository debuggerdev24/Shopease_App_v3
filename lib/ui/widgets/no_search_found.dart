import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NoSearchFound extends StatelessWidget {
  const NoSearchFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.noSearch),
        GlobalText(
          'No Matching search results',
          textStyle: textStyle16,
        ),
      ],
    );
  }
}
