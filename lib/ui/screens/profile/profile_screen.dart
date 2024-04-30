import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/profile_model.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
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
      await context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
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
                  buildProfileTile(provider),
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
                            _showLeavePopUp(context, provider);
                          },
                        ),
                      25.w.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          _showAddMember(context, provider);
                        },
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

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.sp),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              (user.imageUrl == null ||
                                      user.imageUrl?.isEmpty == true)
                                  ? Constants.placeholdeImg
                                  : user.imageUrl ?? '',
                            ),
                          ),
                          title: GlobalText(user.preferredUsername),
                          trailing: user.isInvited == true
                              ? GlobalText(
                                  'Invited',
                                  textStyle: textStyle14,
                                )
                              : SizedBox(
                                  width: 70.sp,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      provider.selectedUserIndex == index
                                          ? SvgIcon(
                                              AppAssets.userEdit,
                                              size: 18.sp,
                                              color: AppColors.blackGreyColor,
                                            )
                                          : const SizedBox(),
                                      GestureDetector(
                                        onTap: () {
                                          provider.deleteUser(user.userId);
                                        },
                                        child: SvgIcon(
                                          AppAssets.delete,
                                          size: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
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
                    subtitle: RichText(
                      text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'If you have any queries, write to ',
                            ),
                            TextSpan(
                              text: 'support@ShopEaseApp.com',
                              style: textStyle12.copyWith(
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                          style: textStyle12.copyWith(
                            color: AppColors.blackColor,
                          )),
                    ),
                  ),
                  20.h.verticalSpace,
                ],
              ),
            );
    });
  }

  void _showAddMember(BuildContext context, ProfileProvider profileProvider) {
    late final TextEditingController mobileController = TextEditingController();
    late final TextEditingController nameController = TextEditingController();
    showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 450.sp,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.sp),
            width: double.infinity,
            child: SingleChildScrollView(
              child: BounceInUp(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlobalText('Add  New Member',
                        textStyle: textStyle18SemiBold),
                    20.h.verticalSpace,
                    9.verticalSpace,
                    AppTextField(
                      controller: nameController,
                      name: "Enter User name",
                      labelText: 'Name',
                      isRequired: true,
                      hintText: "Enter User name",
                      labelStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
                      validator: (value) {
                        if (value != null || value.toString().isNotEmpty) {
                          return '';
                        }
                        return 'Enter valid name';
                      },
                    ),
                    10.h.verticalSpace,
                    9.verticalSpace,
                    AppTextField(
                        controller: mobileController,
                        name: "Enter Mobile NUmber",
                        labelText: 'Mobile Number',
                        isRequired: true,
                        hintText: "enter mobile number with country code",
                        labelStyle: textStyle16.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null || value.toString().isNotEmpty) {
                            return '';
                          }
                          return 'Enter valid mobile number';
                        }),
                    80.h.verticalSpace,
                    AppButton(
                        colorType: (nameController.text.isNotEmpty &&
                                mobileController.text.isNotEmpty)
                            ? AppButtonColorType.primary
                            : AppButtonColorType.secondary,
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              mobileController.text.isNotEmpty) {
                            profileProvider.saveUser(
                              ProfileData(
                                preferredUsername: nameController.text,
                                userId: 'userId',
                                phoneNumber: mobileController.text,
                                imageUrl: Constants.placeholdeImg,
                                isInvited: false,
                              ),
                            );
                            _mobileController.clear();
                            _nameController.clear();
                            context.pop();
                          }
                        },
                        text: 'Invite'),
                    10.h.verticalSpace,
                    AppButton(
                        colorType: AppButtonColorType.greyed,
                        onPressed: () {
                          context.pop();
                          _mobileController.clear();
                          _nameController.clear();
                        },
                        text: 'Cancel'),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showEditProfileBottomSheet() {
    final ValueNotifier<bool> isEnabled = ValueNotifier(false);
    late final TextEditingController mobileController;
    late final TextEditingController nameController;

    nameController = TextEditingController()
      ..addListener(() {
        if (mobileController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          isEnabled.value = true;
        } else {
          isEnabled.value = false;
        }
      });
    mobileController = TextEditingController()
      ..addListener(() {
        if (nameController.text.isNotEmpty &&
            mobileController.text.isNotEmpty) {
          isEnabled.value = true;
        } else {
          isEnabled.value = false;
        }
      });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 500.sp,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: SingleChildScrollView(
            child: Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return BounceInUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GlobalText('Edit Profile',
                          textStyle: textStyle18SemiBold),
                      20.h.verticalSpace,
                      buildTextLabel('Name'),
                      9.verticalSpace,
                      AppTextField(
                        controller: nameController,
                        name: "Enter User name",
                        hintText: "Enter User name",
                        // labelText: "  Product name",
                        labelStyle: textStyle16.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.h.verticalSpace,
                      buildTextLabel('Mobile Number'),
                      9.verticalSpace,
                      AppTextField(
                        controller: mobileController,
                        name: "Enter Mobile Number",
                        hintText: "Mobile Number",
                        // labelText: "  Product name",
                        labelStyle: textStyle16.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.h.verticalSpace,
                      buildTextLabel('Upload Photo'),
                      9.verticalSpace,
                      GestureDetector(
                        onTap: () async {
                          provider.openFilePicker(context);
                          await provider.uploadFile();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: AppColors.mediumGreyColor,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 5,
                                child: Text(
                                  provider.uploadedFilePath ?? "Select a photo",
                                  style: textStyle14.copyWith(
                                    color: AppColors.mediumGreyColor,
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: SvgIcon(
                                  AppAssets.upload,
                                  color: AppColors.blackColor,
                                  size: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      40.h.verticalSpace,
                      ValueListenableBuilder<bool>(
                        valueListenable: isEnabled,
                        builder: (context, value, child) {
                          return AppButton(
                            colorType: value
                                ? AppButtonColorType.primary
                                : AppButtonColorType.secondary,
                            onPressed: () {
                              provider.toggleSet(true);
                              nameController.clear();
                              mobileController.clear();
                              Navigator.pop(context);
                            },
                            text: 'Save',
                          );
                        },
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
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLeavePopUp(BuildContext context, ProfileProvider profileProvider) {
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
                    Consumer<ProfileProvider>(builder: (context, provider, _) {
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
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  profileProvider.selectedUserIndex == entry.key
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
                          CustomToast.showSuccess(
                              context, 'Successfully left the existing group.');
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

  Widget buildProfileTile(ProfileProvider provider) {
    return ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                (provider.profileData?.imageUrl == null ||
                        provider.profileData?.imageUrl?.isEmpty == true)
                    ? Constants.placeholdeImg
                    : provider.profileData?.imageUrl ?? ''),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: SvgPicture.asset(
              AppAssets.update,
              width: 20.sp,
            ),
          ),
        ],
      ),
      title: GlobalText(
        provider.profileData?.preferredUsername ?? 'user name',
        textStyle: textStyle16.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        children: [
          buildProfileRow(
              provider.profileData?.phoneNumber ?? 'phone number', "Change",
              () {
            context.pushNamed(AppRoute.mobileLoginScreen.name, extra: true);
          }),
          2.h.verticalSpace,
          buildProfileRow('email', 'Verify', () {}),
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
}
