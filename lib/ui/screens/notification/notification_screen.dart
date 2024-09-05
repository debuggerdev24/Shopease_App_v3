import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/invitation_model.dart';
import 'package:shopease_app_flutter/models/notification_model.dart';
import 'package:shopease_app_flutter/providers/notifications_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabsController;

  @override
  void initState() {
    super.initState();
    _tabsController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationProvider>().getNotifications();
    });
  }

  @override
  void dispose() {
    _tabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 20.h,
          bottom: TabBar(
            indicatorPadding: EdgeInsets.zero,
            controller: _tabsController,
            indicatorColor: AppColors.orangeColor,
            labelColor: AppColors.orangeColor,
            automaticIndicatorColorAdjustment: true,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (value) {
              if (value == 0) {
                context.read<NotificationProvider>().getNotifications();
              }

              if (value == 1) {
                context.read<NotificationProvider>().getinvitations();
              }
            },
            tabs: [
              _buildTab(
                'Notifications',
                provider.notifications.any((e) => !e.isMessageRead),
              ),
              _buildTab(
                'Invitations',
                provider.invitations.any((e) => !e.isMessageRead),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabsController,
          children: [
            _buildNotificationsList(provider),
            _buildInvitationsView(provider),
          ],
        ),
      );
    });
  }

  _buildTab(String title, bool showBedge) {
    return Tab(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: textStyle20SemiBold,
            ),
          ),
          if (showBedge)
            Positioned(
              top: 0,
              right: -12,
              child: Container(
                height: 18.h,
                width: 19.h,
                alignment: Alignment.bottomLeft,
                child: CircleAvatar(
                  radius: 3.r,
                  backgroundColor: AppColors.redColor,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildNotificationsList(NotificationProvider provider) {
    return provider.notifications.isEmpty
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
                                      'notification_id': e.notificationId
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
                  separatorBuilder: (context, index) => 10.verticalSpace,
                  itemBuilder: (context, index) =>
                      _buildNotificationTile(provider.notifications[index]),
                ),
              ],
            ),
          );
  }

  Widget _buildInvitationsView(NotificationProvider provider) {
    return provider.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : provider.invitations.isEmpty
            ? Center(
                child: GlobalText(
                  'Not have any invitations!',
                  textStyle: textStyle16,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 57.h,
                    color: AppColors.lightYellowColor,
                    child: Row(
                      children: [
                        10.horizontalSpace,
                        const SvgIcon(
                          AppAssets.warning,
                          size: 23,
                        ),
                        10.horizontalSpace,
                        GlobalText(
                          "Joining a group will replace your personal lists with \n the group's list",
                          textStyle: textStyle14.copyWith(
                              fontSize: 13.sp, color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.invitations.length,
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    itemBuilder: (context, index) => _buildInvitationTile(
                        provider, provider.invitations[index]),
                  ),
                ],
              );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
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
            color: AppColors.orangeColor,
            width: 1.5, // Border width
          ),
        ),
        child: CircleAvatar(
          radius: 38.0,
          backgroundColor: AppColors.primaryColor,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: notification.imageUrl ?? Constants.placeholdeImg,
            ),
          ),
        ),
      ),
      title: GlobalText(notification.message),
      trailing: GlobalText(
        notification.recievedDate?.toLocal().toMonthDD ?? '',
        textStyle: textStyle12.copyWith(color: AppColors.blackColor),
      ),
    );
  }

  Widget _buildInvitationTile(
      NotificationProvider provider, Invitation inviteduser) {
    final profileProvider = context.read<ProfileProvider>();
    return Slidable(
      endActionPane: _buildRightSwipeActions(provider, inviteduser),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.sp),
        tileColor: AppColors.whiteColor,
        leading: Container(
          height: 70,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.orangeColor,
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: 8.0,
            backgroundColor: AppColors.primaryColor,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: (profileProvider.profileData?.imageUrl == null ||
                        profileProvider.profileData?.imageUrl.isEmpty == true)
                    ? Constants.placeholdeImg
                    : profileProvider.profileData?.imageUrl ?? '',
              ),
            ),
          ),
        ),
        title: GlobalText(
          'There is an Invitation from ${inviteduser.invitedBy} to join group',
          textStyle:
              textStyle14.copyWith(color: AppColors.greyColor, fontSize: 17),
        ),
        trailing: GlobalText(
          inviteduser.lastUpdatedDate.toLocal().toMonthDD,
          textStyle: textStyle12.copyWith(color: AppColors.greyColor),
        ),
      ),
    );
  }

  _buildRightSwipeActions(
          NotificationProvider provider, Invitation invitation) =>
      ActionPane(
        motion: const DrawerMotion(),
        children: [
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.acceptInvitation,
            forgroundColor: null,
            backgroundColor: AppColors.greenColor,
            onTap: () async {
              await provider.acceptinvite(
                data: {
                  "user_id": invitation.userId,
                  "location_id": invitation.locationId,
                },
                onSuccess: () {
                  CustomToast.showSuccess(context, 'Invitation Accepted.');
                  provider.removeInvitation(invitation);
                },
                onError: (msg) {
                  CustomToast.showError(context, msg);
                },
              );
            },
            isAsset: true,
            height: 90.sp,
          ),
          AppSlidableaction(
            isRight: true,
            icon: AppAssets.removeinviteuser,
            onTap: () async {
              await provider.rejectinvite(
                data: {
                  "user_id": invitation.userId,
                  "location_id": invitation.locationId,
                },
                onSuccess: () {
                  CustomToast.showWarning(context, 'Invitation rejected.');
                  provider.removeInvitation(invitation);
                },
                onError: (msg) {
                  CustomToast.showError(context, msg);
                },
              );
            },
            forgroundColor: null,
            backgroundColor: AppColors.redColor,
            isAsset: true,
            height: 70.sp,
          ),
        ],
      );
}
