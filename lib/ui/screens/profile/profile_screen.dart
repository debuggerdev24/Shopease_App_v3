import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/invitation_model.dart';
import 'package:shopease_app_flutter/models/profile_model.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/mobile_field.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ProfileProvider>().getProfile(onSuccess: () {
        context.read<ProfileProvider>().getAllProfile();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    50.h.verticalSpace,
                    GlobalText(
                      'My Profile',
                      textStyle: appBarTitleStyle.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 25.sp),
                    ),
                    20.h.verticalSpace,
                    _buildProfileTile(provider),
                    20.h.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GlobalText(
                          'My Group (${provider.groupProfiles.length})',
                          textStyle: textStyle16,
                        ),
                        const Spacer(),
                        if (provider.groupProfiles.isNotEmpty)
                          GestureDetector(
                            child: GlobalText(
                              'Leave Group',
                              textStyle: textStyle12.copyWith(
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              _showLeaveGroupSheet(provider);
                            },
                          ),
                        25.w.horizontalSpace,
                        GestureDetector(
                          onTap: _showAddMemberSheet,
                          child: SvgIcon(
                            AppAssets.add,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                        ),
                        4.w.horizontalSpace,
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: provider.groupProfiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        ProfileData user = provider.groupProfiles[index];
                        log("usdert =====>${user.userId}");

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.sp),
                          leading: _buildProfilePicture(
                            user.isAdmin,
                            (user.imageUrl.isEmpty == true)
                                ? Constants.placeholdeImg
                                : user.imageUrl,
                          ),
                          title: GlobalText(user.phoneNumber),
                          trailing: _buildTrailingRow(provider, user),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: GlobalText(
                        'Support',
                        textStyle:
                            textStyle16.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppAssets.support,
                        ),
                      ),
                    ),
                    20.h.verticalSpace,
                  ],
                ),
              );
      },
    );
  }

  Widget _buildTrailingRow(ProfileProvider provider, ProfileData user) {
    return user.isInvited == true
        ? GlobalText(
            'Invited',
            textStyle: textStyle14,
          )
        : provider.profileData?.isAdmin == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!user.isAdmin) ...[
                    SvgIcon(
                      AppAssets.userEdit,
                      size: 15.sp,
                      color: AppColors.blackGreyColor,
                    ),
                    15.horizontalSpace
                  ],
                  GestureDetector(
                    onTap: () async {
                      await provider.removeUserFromGroup(
                        data: {'user_id': user.userId},
                        onSuccess: () {
                          CustomToast.showSuccess(
                            context,
                            'User removed successfully.',
                          );
                        },
                      );
                    },
                    child: SvgIcon(
                      AppAssets.delete,
                      size: 16.sp,
                    ),
                  )
                ],
              )
            : const SizedBox.shrink();
  }

  void _showAddMemberSheet() {
    final TextEditingController mobileController = TextEditingController();
    showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, rebuild) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.sp),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Consumer2<ProfileProvider, AuthProvider>(
                    builder: (context, provider, auth, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlobalText('Add  New User', textStyle: textStyle16),
                      20.h.verticalSpace,
                      MobileField(
                        controller: mobileController,
                        onTextChanged: (_) {
                          rebuild(() {});
                        },
                      ),
                      20.h.verticalSpace,
                      AppButton(
                          colorType: !(mobileController.text.length ==
                                  auth.selectedCountry.example.length)
                              ? AppButtonColorType.greyed
                              : AppButtonColorType.primary,
                          onPressed: !(mobileController.text.length ==
                                  auth.selectedCountry.example.length)
                              ? () {
                                  CustomToast.showWarning(context,
                                      'Please enter valid mobile number');
                                }
                              : () async {
                                  if (mobileController.text.isNotEmpty) {
                                    await provider.inviteUserToGroup(
                                      data: {
                                        'phone_number':
                                            '+${auth.selectedCountry.phoneCode}${mobileController.text}',
                                      },
                                      onSuccess: () {
                                        mobileController.clear();
                                        context.pop();
                                      },
                                      onError: (msg) {
                                        CustomToast.showError(context, msg);
                                      },
                                    );
                                  }
                                },
                          text: 'Invite'),
                      10.h.verticalSpace,
                      AppButton(
                          colorType: AppButtonColorType.greyed,
                          onPressed: () {
                            context.pop();
                            mobileController.clear();
                          },
                          text: 'Cancel'),
                    ],
                  );
                }),
              ),
            );
          });
        });
  }

  void _showEditProfileBottomSheet() {
    log('user name: ${context.read<ProfileProvider>().profileData!.preferredUsername}');
    final TextEditingController nameController = TextEditingController()
      ..text = context.read<ProfileProvider>().profileData!.preferredUsername;
    final TextEditingController mobileController = TextEditingController();
    // log('image url: ${context.read<ProfileProvider>().profileData!.imageUrl}');
    final TextEditingController fileFieldController = TextEditingController();
    // ..text = context.read<ProfileProvider>().profileData!.imageUrl;

    onSelectFileTap() async {
      final name = await context.read<ProfileProvider>().selectFile();
      if (name != null) {
        fileFieldController.text = name;
      }
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Consumer<ProfileProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlobalText('Edit Profile', textStyle: textStyle18SemiBold),
                  20.h.verticalSpace,
                  9.verticalSpace,
                  AppTextField(
                    controller: nameController,
                    name: "Enter User name",
                    hintText: "Enter User name",
                    labelText: "Name",
                    isRequired: true,
                    labelStyle: textStyle16.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  10.h.verticalSpace,
                  AppTextField(
                    name: 'productImg',
                    controller: fileFieldController,
                    maxLines: 1,
                    readOnly: true,
                    isRequired: true,
                    labelText: 'Upload Photo',
                    hintText: 'Select a photo',
                    bottomText: 'Max File Size:5MB',
                    onTap: onSelectFileTap,
                    suffixIcon: fileFieldController.text.isEmpty
                        ? IconButton(
                            onPressed: onSelectFileTap,
                            icon: SvgIcon(
                              AppAssets.upload,
                              color: AppColors.blackColor,
                              size: 18.sp,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              fileFieldController.clear();
                              provider.clearFile();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                  ),
                  40.h.verticalSpace,
                  AppButton(
                    colorType: (nameController.text.isNotEmpty &&
                            fileFieldController.text.isNotEmpty)
                        ? AppButtonColorType.primary
                        : AppButtonColorType.secondary,
                    isLoading: provider.editProfileLoading,
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        CustomToast.showWarning(context, 'Enter valid name');
                        return;
                      }
                      if (fileFieldController.text.isEmpty) {
                        CustomToast.showWarning(
                            context, 'Upload a valid image');
                        return;
                      }

                      if (nameController.text.isNotEmpty &&
                          fileFieldController.text.isNotEmpty) {
                        provider.toggleSet(true);
                        await provider.editProfile(
                          data: [
                            {
                              'preferred_username': nameController.text,
                              'profile_image': provider.selectedFile?.path,
                            }
                          ],
                          isEdit: false,
                          onSuccess: () {
                            context.pop();
                            provider.getProfile();
                            nameController.clear();
                            mobileController.clear();
                          },
                          onError: (msg) {
                            CustomToast.showError(
                              context,
                              Constants.commonErrMsg,
                            );
                          },
                        );
                      }
                    },
                    text: 'Save',
                  ),
                  10.h.verticalSpace,
                  AppButton(
                    colorType: AppButtonColorType.greyed,
                    onPressed: () {
                      nameController.clear();
                      mobileController.clear();
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    text: 'Cancel',
                  ),
                  10.h.verticalSpace,
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showLeaveGroupSheet(ProfileProvider profileProvider) {
    log(profileProvider.uninvitedUsers.length.toString());
    log("userList length: ${profileProvider.userList.length}");
    log("uninvitedUsers length: ${profileProvider.uninvitedUsers.length}");

    // Ensure uninvitedUsers is updated
    profileProvider.updateUninvitedUsers();

    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, rebuild) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: BounceInUp(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GlobalText('Assign & Leave',
                          textStyle: textStyle18SemiBold),
                      20.h.verticalSpace,
                      Consumer<ProfileProvider>(
                          builder: (context, provider, _) {
                        return Column(
                          children: profileProvider.groupProfiles
                              .asMap()
                              .entries
                              .map((entry) {
                            final ProfileData user = entry.value;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  profileProvider.changeSelectedUser(entry.key);
                                  rebuild(() {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    profileProvider.selectedUserIndex ==
                                            entry.key
                                        ? const SvgIcon(
                                            AppAssets.check,
                                            color: AppColors.primaryColor,
                                          )
                                        : const SizedBox.shrink(),
                                    20.horizontalSpace,
                                    GlobalText(
                                      user.preferredUsername,
                                      fontSize: 15.sp,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      30.h.verticalSpace,
                      AppButton(
                          colorType: profileProvider.selectedUserIndex == -1
                              ? AppButtonColorType.greyed
                              : AppButtonColorType.primary,
                          onPressed: () {
                            profileProvider.clearGroupProfiles();
                            context.pop();
                            CustomToast.showSuccess(context,
                                'Successfully left the existing group.');
                          },
                          text: 'Assign & Leave'),
                      10.h.verticalSpace,
                      AppButton(
                          colorType: AppButtonColorType.greyed,
                          onPressed: () {
                            context.pop();
                          },
                          text: 'Changed my Mind'),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget buildTextLabel(String name) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '*',
          style: const TextStyle(color: Colors.red, fontSize: 17),
          children: <TextSpan>[
            TextSpan(
              text: name,
              style: textStyle16.copyWith(
                  color: AppColors.blackColor, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  buildProfileRow(String str1, String str2, VoidCallback ontap) {
    return Row(
      children: [
        GlobalText(
          str1,
          textStyle: textStyle16.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.blackGreyColor.withOpacity(0.6),
              fontSize: 13.sp),
        ),
        15.w.horizontalSpace,
        GestureDetector(
          onTap: ontap,
          child: GlobalText(
            str2,
            textStyle: textStyle16.copyWith(
                decoration: TextDecoration.underline, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile(ProfileProvider provider) {
    return ListTile(
      isThreeLine: false,
      contentPadding: EdgeInsets.zero,
      leading: _buildProfilePicture(
          provider.profileData?.isAdmin == true,
          (provider.profileData?.imageUrl == null ||
                  provider.profileData?.imageUrl.isEmpty == true)
              ? Constants.placeholdeImg
              : provider.profileData?.imageUrl ?? ''),
      title: GlobalText(
        provider.profileData?.preferredUsername ?? 'user name',
        textStyle: textStyle16.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        children: [
          buildProfileRow(
              provider.profileData?.phoneNumber ?? 'phone number', '', () {
            context.pushNamed(AppRoute.mobileLoginScreen.name, extra: true);
          }),
          // 2.h.verticalSpace,
          // buildProfileRow('email', 'Verify', () {}),
        ],
      ),
      trailing: GestureDetector(
        onTap: _showEditProfileBottomSheet,
        child: SvgIcon(
          AppAssets.edit,
          color: AppColors.blackGreyColor,
          size: 20.sp,
        ),
      ),
    );
  }

  _buildProfilePicture(bool isAdmin, String url) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(url),
        ),
        if (isAdmin)
          Positioned(
            bottom: 0,
            right: 5,
            child: SvgPicture.asset(
              AppAssets.update,
              width: 20.sp,
            ),
          ),
      ],
    );
  }
}
