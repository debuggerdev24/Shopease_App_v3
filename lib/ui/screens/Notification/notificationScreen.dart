import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          50.h.verticalSpace,
          GlobalText(
            '    Notifications',
            textStyle: appBarTitleStyle.copyWith(
                fontWeight: FontWeight.w600, fontSize: 25.sp),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: GlobalText(
                  color: AppColors.orangeColor,
                  'Mark as all read',
                  textStyle: textStyle14.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.orangeColor,
                    color: AppColors.orangeColor,
                  )),
            ),
          ),
          10.h.verticalSpace,
          buildMessageTile('Invitation Notificaiton'),
          buildMessageTile('A new product has been added to the checklist.'),
          buildMessageTile('Upload invoice remainder (action based)'),
        ],
      ),
    );
  }

  Widget buildMessageTile(String msg) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 4.sp),
      padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 10.sp),
      color: Colors.grey.withOpacity(0.1), // Set the desired color here
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.orangeColor, // Border color
              width: 1.5, // Border width
            ),
          ),
          child: CircleAvatar(
            radius: 38.0,
            child: ClipOval(
              child: Image.asset(AppAssets.user),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
        title: GlobalText(msg),
        trailing: GlobalText(
          'Today',
          textStyle: textStyle12.copyWith(color: AppColors.darkGreyColor),
        ),
      ),
    );
  }
}
