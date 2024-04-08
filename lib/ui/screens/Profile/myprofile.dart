import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
//   final List<Map<String, String>> userList = [
//     {
//       'img': AppAssets.lucy,
//       'name': 'Lucy',
//     },
//     {
//       'img': AppAssets.joe,
//       'name': 'Joe',
//     },
//     {
//       'img': AppAssets.noImage,
//       'name': 'Manoj',
//     },
//     {
//       'img': AppAssets.noImage,
//       'name': 'Riya',
//     },
//   ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SharedPrefs sharedPrefs = SharedPrefs();

    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return Container(
        color: AppColors.whiteColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.h.verticalSpace,
              GlobalText(
                '  My Profile',
                textStyle: appBarTitleStyle.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 25.sp),
              ),
              20.h.verticalSpace,
              buildProfileTile(() {
                _showEditProfileBottomSheet(context);
              }, provider, sharedPrefs),
              20.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GlobalText(
                      provider.userList.isEmpty
                          ? ' My Group (0)'
                          : ' My Group (${provider.userList.length}/12)',
                      textStyle: textStyle16,
                    ),
                    Spacer(),
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
              ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: provider.userList.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> user = provider.userList[index];
                  provider.selectedUserIndex == index;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.sp),
                    child: ListTile(
                      leading: provider.set
                          ? BounceInDown(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors
                                            .orangeColor, // Border color
                                        width: 1.5, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40.sp,
                                      child: CircleAvatar(
                                        radius: 38.0,
                                        child: ClipOval(
                                          child:
                                              // Image.asset(AppAssets.user), // Display user image
                                              Image.asset(
                                                  user['img'].toString()),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  provider.selectedUserIndex == index
                                      ? Positioned(
                                          bottom: 15,
                                          right: 8,
                                          child: SvgPicture.asset(
                                            AppAssets.update,
                                            width: 20.sp,
                                          ))
                                      : SizedBox(),
                                ],
                              ),
                            )
                          : BounceInUp(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors
                                            .orangeColor, // Border color
                                        width: 1.5, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40.sp,
                                      child: CircleAvatar(
                                        radius: 38.0,
                                        child: ClipOval(
                                          child:
                                              // Image.asset(AppAssets.user), // Display user image
                                              Image.asset(
                                                  user['img'].toString()),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  provider.selectedUserIndex == index
                                      ? Positioned(
                                          bottom: 15,
                                          right: 8,
                                          child: SvgPicture.asset(
                                            AppAssets.update,
                                            width: 20.sp,
                                          ))
                                      : SizedBox(),
                                ],
                              ),
                            ),
                      title: GlobalText(user['name'].toString()),
                      trailing: user['invite']
                          ? GlobalText(
                              'Invited',
                              textStyle: textStyle14,
                            )
                          : Container(
                              width: 70.sp,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  provider.selectedUserIndex == index
                                      ? SvgIcon(
                                          AppAssets.userEdit,
                                          size: 18.sp,
                                          color: AppColors.blackGreyColor,
                                        )
                                      : SizedBox(),
                                  GestureDetector(
                                    onTap: () {
                                      provider
                                          .deleteUser(user['img'].toString());
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
                onTap: () {
                  provider.toggleSet(provider.set);
                },
                title: GlobalText(
                  'Support',
                  textStyle: textStyle16.copyWith(fontWeight: FontWeight.w500),
                ),
                trailing: SvgIcon(
                  AppAssets.arrow,
                  color: AppColors.blackGreyColor,
                ),
                tileColor: AppColors.whiteColor,
              ),
              provider.set
                  ? Column(
                      children: [
                        GlobalText(
                          '    If you have any queries, write to ',
                          fontSize: 12.sp,
                          color: AppColors.lightGreyColor.withOpacity(0.8),
                        ),
                        2.h.verticalSpace,
                        GlobalText(
                          'support@ShopEaseApp.com',
                          textDecoration: TextDecoration.underline,
                          fontSize: 12.sp,
                          color: AppColors.lightGreyColor.withOpacity(0.8),
                        ),
                      ],
                    )
                  : SizedBox(),
              20.h.verticalSpace,
            ],
          ),
        ),
      );
    });
  }

  void _showAddMember(BuildContext context, ProfileProvider profileProvider) {
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
                    buildTextLabel('Name'),
                    9.verticalSpace,
                    AppTextField(
                      controller: nameController,
                      name: "Enter User name",
                      hintText: "Enter User name",
                      labelStyle: textStyle16.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400),
                    ),
                    10.h.verticalSpace,
                    buildTextLabel('Mobile Number'),
                    9.verticalSpace,
                    AppTextField(
                      controller: mobileController,
                      name: "Enter Mobile NUmber",
                      hintText: "Mobile Number",
                      labelStyle: textStyle16.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.phone,
                    ),
                    80.h.verticalSpace,
                    ValueListenableBuilder<bool>(
                        valueListenable: isEnabled,
                        builder: (context, value, child) {
                          return AppButton(
                              colorType: isEnabled.value
                                  ? AppButtonColorType.primary
                                  : AppButtonColorType.secondary,
                              onPressed: () {
                                if (isEnabled.value) {
                                  context.pop();
                                  profileProvider.saveUser(
                                    {
                                      'img': AppAssets.noImage,
                                      'name': nameController.text,
                                      'admin': false,
                                      'phone': int.parse(mobileController.text),
                                      'invite': true,
                                    },
                                  );

                                  _mobileController.clear();
                                  _nameController.clear();
                                }
                              },
                              text: 'Invite');
                        }),
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

  void _showEditProfileBottomSheet(BuildContext context) {
    final ValueNotifier<bool> isEnabled = ValueNotifier(false);
    late final TextEditingController _mobileController;
    late final TextEditingController _nameController;

    _nameController = TextEditingController()
      ..addListener(() {
        if (_mobileController.text.isNotEmpty &&
            _nameController.text.isNotEmpty) {
          isEnabled.value = true;
        } else {
          isEnabled.value = false;
        }
      });
    _mobileController = TextEditingController()
      ..addListener(() {
        if (_nameController.text.isNotEmpty &&
            _mobileController.text.isNotEmpty) {
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
                        controller: _nameController,
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
                        controller: _mobileController,
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
                              _nameController.clear();
                              _mobileController.clear();
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
                          _nameController.clear();
                          _mobileController.clear();
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
                    Column(
                      children: profileProvider.uninvitedUsers
                          .asMap()
                          .entries
                          .map((entry) {
                        final int index = entry.key;
                        final Map<String, dynamic> user = entry.value;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              profileProvider.changeSelectedUser(index);
                              CustomToast.showSuccess(context,
                                  'New Admin has been assigned to the group');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                profileProvider.selectedUserIndex == index
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.sp,
                                          vertical: 1.sp,
                                        ),
                                        child: const SvgIcon(
                                          AppAssets.check,
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : SizedBox(width: 20.sp),
                                2.horizontalSpace,
                                GlobalText(
                                  user['name'].toString(),
                                  fontSize: 15.sp,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    30.h.verticalSpace,
                    AppButton(
                        colorType: profileProvider.selectedUserIndex == -1
                            ? AppButtonColorType.greyed
                            : AppButtonColorType.primary,
                        onPressed: () {
                          profileProvider
                              .deleteUserList(profileProvider.userList);

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

  Widget buildProfileTile(VoidCallback ontap, ProfileProvider profileProvider,
      SharedPrefs sharedPrefs) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.lightGreyColor.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileProvider.set
                ? BounceInUp(
                    child: InkWell(
                      onTap: () => _showEditProfileBottomSheet(context),
                      // onTap: getImage, // Assuming getImage is your function to update the image
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 40.sp,
                            child: CircleAvatar(
                              radius: 38.0,
                              child: ClipOval(
                                child:
                                    // Image.asset(AppAssets.user), // Display user image
                                    Image.asset(
                                        ProfileProvider().uploadedFilePath ??
                                            AppAssets.user),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 0,
                              child: SvgPicture.asset(
                                AppAssets.update,
                                width: 20.sp,
                              )),
                        ],
                      ),
                    ),
                  )
                : BounceInDown(
                    child: InkWell(
                      onTap: () => _showEditProfileBottomSheet(context),
                      // onTap: getImage, // Assuming getImage is your function to update the image
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 40.sp,
                            child: CircleAvatar(
                              radius: 38.0,
                              child: ClipOval(
                                child:
                                    // Image.asset(AppAssets.user), // Display user image
                                    Image.asset(
                                        ProfileProvider().uploadedFilePath ??
                                            AppAssets.user),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 0,
                              child: SvgPicture.asset(
                                AppAssets.update,
                                width: 20.sp,
                              )),
                        ],
                      ),
                    ),
                  ),
            15.w.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.h.verticalSpace,
                GlobalText(
                  sharedPrefs.userName ?? 'Jessica',
                  textStyle: textStyle16.copyWith(fontWeight: FontWeight.w500),
                ),
                2.h.verticalSpace,
                buildProfileRow(sharedPrefs.phone ?? '8888987121', "Change",
                    () {
                  context.pushNamed(AppRoute.mobileLoginScreen.name,
                      extra: true);
                }),
                2.h.verticalSpace,
                buildProfileRow('abc@gmail.com', 'Verify', () {}),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                child: GestureDetector(
                  onTap: ontap,
                  child: SvgIcon(
                    AppAssets.edit,
                    color: AppColors.blackGreyColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            20.w.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
