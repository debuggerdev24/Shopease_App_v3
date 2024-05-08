import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/notification_model.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GlobalText(
          'Notifications',
          textStyle: appBarTitleStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 25.sp),
        ),
      ),
      body: Consumer<NotificationProvider>(builder: (context, provider, _) {
        return provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.notifications.isEmpty
                ? Center(
                    child: GlobalText(
                      'Not have any notifications!',
                      textStyle: textStyle16,
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.notifications
                            .any((element) => !element.isMessageRead))
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                provider.updateNotifications(
                                    data: provider.notifications
                                        .map((e) => {
                                              'is_message_read': true,
                                              'notification_id':
                                                  e.notificationId
                                            })
                                        .toList());
                              },
                              child: GlobalText(
                                color: AppColors.orangeColor,
                                'Mark as all read',
                                textStyle: textStyle14.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.orangeColor,
                                  color: AppColors.orangeColor,
                                ),
                              ),
                            ),
                          ),
                        10.h.verticalSpace,
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.notifications.length,
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          itemBuilder: (context, index) =>
                              buildMessageTile(provider.notifications[index]),
                        ),
                      ],
                    ),
                  );
      }),
    );
  }

  Widget buildMessageTile(NotificationModel notification) {
    return ListTile(
      onTap: () {
        context.read<NotificationProvider>().updateNotifications(data: [
          {
            'is_message_read': true,
            'notification_id': notification.notificationId,
          }
        ]);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.sp),
      tileColor: notification.isMessageRead
          ? Colors.grey.withOpacity(0.1)
          : AppColors.orangeColor.withAlpha(50),
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
          backgroundColor: AppColors.primaryColor,
          child: ClipOval(
            child:
                Image.network(notification.imageUrl ?? Constants.placeholdeImg),
          ),
        ),
      ),
      title: GlobalText(notification.message),
      trailing: GlobalText(
        notification.recievedDate?.toMonthDD ?? '',
        textStyle: textStyle12.copyWith(color: AppColors.blackColor),
      ),
    );
  }
}
