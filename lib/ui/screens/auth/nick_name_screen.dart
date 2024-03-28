import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NickNameScreen extends StatelessWidget {
  NickNameScreen({super.key});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElasticInRight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.h.verticalSpace,
                Text(
                  'What is your nick name?',
                  style: textStyle20SemiBold.copyWith(fontSize: 24),
                ),
                20.verticalSpace,
                AppTextField(
                  name: 'nickNameField',
                  controller: _nameController,
                  hintText: 'jonathan_peeres',
                ),
                20.h.verticalSpace,
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.sp, vertical: 20.sp),
                  child: AppButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty)
                          context
                              .pushNamed(AppRoute.congratulationsScreen.name);
                        else {
                          CustomToast.showWarning(
                              context, 'Please enter nick name');
                        }
                      },
                      text: 'Continue'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
