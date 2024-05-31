import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/Models/invitation_model.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_slidable_action.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';

import '../../../utils/styles.dart';

class InvitationsView extends StatefulWidget {
  const InvitationsView({
    super.key,
  });

  @override
  State<InvitationsView> createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView>
    with SingleTickerProviderStateMixin {
  late SlidableController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = SlidableController(this);

    context.read<ProfileProvider>().getinvitesbyuser();
  }

  @override
  dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentListView(context),
    );
  }

  Widget _buildCurrentListView(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.inviteduser.isEmpty
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
                      itemCount: provider.inviteduser.length,
                      separatorBuilder: (context, index) => 10.verticalSpace,
                      itemBuilder: (context, index) => _buildInvitationTile(
                          provider, provider.inviteduser[index], context),
                    ),
                  ],
                );
    });
  }

  Widget _buildInvitationTile(
      ProfileProvider provider, Inviteduser inviteduser, BuildContext context) {
    return Slidable(
      endActionPane: _buildRightSwipeActions(provider, inviteduser, context),
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
              child: Image.network((provider.profileData?.imageUrl == null ||
                      provider.profileData?.imageUrl.isEmpty == true)
                  ? Constants.placeholdeImg
                  : provider.profileData?.imageUrl ?? ''),
            ),
          ),
        ),
        title: GlobalText(
          'There is an Invitation from ${inviteduser.invitedBy} to join group',
          textStyle:
              textStyle14.copyWith(color: AppColors.greyColor, fontSize: 17),
        ),
        trailing: GlobalText(
          inviteduser.lastUpdatedDate.toMonthDD,
          textStyle: textStyle12.copyWith(color: AppColors.greyColor),
        ),
      ),
    );
  }

  _buildRightSwipeActions(
    ProfileProvider provider,
    Inviteduser inviteduser,
    BuildContext context,
  ) =>
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
                  "user_id": inviteduser.userId,
                  "location_id": inviteduser.locationId,
                },
                onSuccess: () {
                  CustomToast.showSuccess(context, 'Invitation Accepted.');
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
                    "user_id": inviteduser.userId,
                  },
                  onError: (msg) {
                    CustomToast.showError(context, msg);
                  },
                  onSuccess: () {
                    CustomToast.showWarning(context, 'Invitation rejected.');
                  });
            },
            forgroundColor: null,
            backgroundColor: AppColors.redColor,
            isAsset: true,
            height: 74.sp,
          ),
        ],
      );
}
