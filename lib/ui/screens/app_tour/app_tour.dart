import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final invTabButtonKey = GlobalKey(debugLabel: 'invTabButton');
final scanInvButtonKey = GlobalKey(debugLabel: 'scanInvButton');
final addInvButtonKey = GlobalKey(debugLabel: 'addInvButton');
final adDInvSheetKey = GlobalKey(debugLabel: 'addInvSheet');
final checkListTabButtonKey = GlobalKey(debugLabel: 'checkListTabButton');
final selectShopButtonKey = GlobalKey(debugLabel: 'selectShopButton');
final addInvoiceButtonKey = GlobalKey(debugLabel: 'addInvoiceButton');
final addMemberButtonKey = GlobalKey(debugLabel: 'addMemberButton');

final List<TargetFocus> targets = [
  createTargetFocus(
    key: invTabButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.top,
        text:
            "Inventory list to consolidate and organize all products in one place.",
      ),
    ],
  ),
  createTargetFocus(
    key: scanInvButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.bottom,
        text:
            "Scan the barcode to add products to the inventory list without any hassles.",
      ),
    ],
  ),
  createTargetFocus(
    key: addInvButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.bottom,
        text:
            "You can manually add products at any time by using this option as needed.",
      ),
    ],
  ),
  createTargetFocus(
    key: checkListTabButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.top,
        text: "A checklist to add products you want to review at the shop.",
      ),
    ],
  ),
  createTargetFocus(
    key: selectShopButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.bottom,
        text:
            "Select your favourite shops where you can purchase products according to your preferences.",
      ),
    ],
  ),
  createTargetFocus(
    key: addMemberButtonKey,
    contents: [
      createTargetContent(
        align: ContentAlign.bottom,
        text:
            "Create a group with your family members to instantly share lists",
      ),
    ],
  ),
];

TargetFocus createTargetFocus(
    {required GlobalKey key, required List<TargetContent> contents}) {
  return TargetFocus(
    keyTarget: key,
    enableOverlayTab: true,
    shape: ShapeLightFocus.RRect,
    radius: 0,
    borderSide: const BorderSide(color: AppColors.orangeColor, width: 2),
    contents: contents,
  );
}

TargetContent createTargetContent(
    {required String text, required ContentAlign align}) {
  return TargetContent(
    align: ContentAlign.bottom,
    child: SizedBox(
      width: 100,
      child: Text(
        text,
        style: textStyle16.copyWith(color: AppColors.whiteColor),
      ),
    ),
  );
}

TutorialCoachMark getTutorial() {
  return TutorialCoachMark(
    targets: targets,
    colorShadow: AppColors.lightGreyColor.withAlpha(200),
    onFinish: () {
      log("finish");
    },
    onClickTargetWithTapPosition: (target, tapDetails) {
      log("target: $target");
      log("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
    },
    onClickTarget: (target) {
      log(target.toString());
    },
    onSkip: () {
      log("skip");
      return true;
    },
  );

  // tutorial.skip();
  // tutorial.finish();
  // tutorial.next(); // call next target programmatically
  // tutorial.previous(); // call previous target programmatically
  // tutorial.goTo(3); // call target programmatically by index
}
