// Store all of your images, icons, svgs, gifs, llotties path here

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';

class AppAssets {
  AppAssets._();

  static const String appLogo = "assets/images/logo.png";
  static const String scanner1 = "assets/images/scanner.png";
  static const String onBoard1 = "assets/images/splash1.png";
  static const String onBoard2 = "assets/images/splash2.png";
  static const String onBoard3 = "assets/images/splash3.png";
  static const String congo = "assets/images/congo.png";
  static const String apple = "assets/images/apple1.png";
  static const String apple2 = "assets/images/apple2.png";
  static const String user = "assets/images/user.png";
  static const String joe = "assets/images/joe.png";
  static const String invoice = "assets/images/invoice.png";

  static const String errorWarning = 'assets/icons/error_warning.svg';

  static const String lucy = "assets/images/lucy.png";
  static const String noUser = "assets/images/noUser.png";
  static const String leaf = "assets/images/leaf.png";
  static const String orange = "assets/images/orange.png";
  static const String noImage = "assets/images/noImage.png";
  static const String beetroot = "assets/images/beetroot.png";
  static const String doitlater = "assets/images/doit_later.png";
  static const String addInventory = "assets/images/addInventory.png";
  static const String noSearch = "assets/images/no_search.png";
  static const String devider = "assets/images/devider.png";
  static const String delete = "assets/icons/delete.svg";

  static const String tickMark = "assets/icons/tick_mark.svg";
  //Bottombar
  static const String index = "assets/icons/index.svg";
  static const String addInvoice = "assets/icons/add_invoice.svg";
  static const String addtocart = "assets/icons/addtocart.svg";
  static const String addCart = "assets/icons/addCart.svg";
  static const String succcessCart = "assets/icons/succcessCart.svg";
  static const String menu = "assets/icons/menu.svg";
  static const String notification = "assets/icons/notification.svg";
  static const String person = "assets/icons/person.svg";
  static const String inventoryLow = "assets/icons/low_level.svg";
  static const String inventoryMid = "assets/icons/medium_level.svg";
  static const String inventoryHigh = "assets/icons/high_level.svg";
  static const String edit = "assets/icons/edit.svg";
  static const String checkList = "assets/icons/checkList.svg";
  static const String selectedFilterIcon =
      "assets/icons/selected_filter_icon.svg";
  static const String filterIcon = "assets/icons/filter.svg";
  static const String upload = "assets/icons/upload.svg";
  static const String dropDown = "assets/icons/dropDown.svg";
  static const String cancel = "assets/icons/cancel.svg";
  static const String check = "assets/icons/check.svg";
  static const String update = "assets/icons/update.svg";
  static const String replace = "assets/icons/replace.svg";
  static const String arrow = "assets/icons/arrow.svg";
  static const String arrowLeft = "assets/icons/arrowLeft.svg";
  static const String toastCheck = "assets/icons/toastCheck.svg";
  static const String errorToast = "assets/icons/errorToast.svg";
  static const String addToCheck = "assets/icons/addToCheck.svg";
  static const String rmCart = "assets/icons/rmCart.svg";
  static const String calender = "assets/icons/calender.svg";
  static const String scanner = "assets/icons/scanner.svg";
  static const String search = "assets/icons/search.svg";
  static const String add = "assets/icons/add.svg";
  static const String userEdit = "assets/icons/userEdit.svg";
  static const String zoomIcon = "assets/icons/zoom.svg";
  static const String acceptInvitation = "assets/icons/acceptinvite.png";
  static const String removeInviteUser = "assets/icons/deletinvitation.png";
  static const String support = "assets/icons/support.svg";
  static const String warning = "assets/icons/warning.svg";
  static const String noConnectionBG = "assets/images/no_internet_bg.png";
  static const String oops = "assets/images/oops.svg";
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(this.iconPath, {super.key, double size = 14, this.color})
      : width = size,
        height = size;
  final String iconPath;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const Color srcColor = AppColors.orangeColor;
    return SvgPicture.asset(iconPath,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color ?? srcColor, BlendMode.srcIn));
  }
}
