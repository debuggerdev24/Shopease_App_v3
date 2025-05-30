import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final invTabButtonKey = GlobalKey(debugLabel: 'invTabButton');
final scanInvButtonKey = GlobalKey(debugLabel: 'scanInvButton');
final addInvButtonKey = GlobalKey(debugLabel: 'addInvButton');
final addInvSheetKey = GlobalKey(debugLabel: 'addInvSheet');
final checkListTabButtonKey = GlobalKey(debugLabel: 'checkListTabButton');
final selectShopButtonKey = GlobalKey(debugLabel: 'selectShopButton');
final addInvoiceButtonKey = GlobalKey(debugLabel: 'addInvoiceButton');
final profileTabButtonKey = GlobalKey(debugLabel: 'profileTabButton');
final addMemberButtonKey = GlobalKey(debugLabel: 'addMemberButton');

final List<TargetFocus> inventoryTargets = [
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
  // createTargetFocus(
  //   key: addInvSheetKey,
  //   contents: [
  //     createTargetContent(
  //       align: ContentAlign.bottom,
  //       text:
  //           "No matter which option yiu choose,adding product to your inventory is quick and convenient.",
  //     ),
  //   ],
  // ),
  createTargetFocus(
    key: checkListTabButtonKey,
    // enableTargetTab: false,
    contents: [
      createTargetContent(
        align: ContentAlign.top,
        text: "A checklist to add products you want to review at the shop.",
      ),
    ],
  ),
];

final List<TargetFocus> checklistTargets = [
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
  // createTargetFocus(
  //   key: addInvoiceButtonKey,
  //   contents: [
  //     createTargetContent(
  //       align: ContentAlign.bottom,
  //       text: "Include an invoice to maintain a record for future reference.",
  //     ),
  //   ],
  // ),
  createTargetFocus(
    key: profileTabButtonKey,
    // enableTargetTab: false,
    contents: [],
  ),
];

final List<TargetFocus> profileTargets = [
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

TutorialCoachMark getInventoryTutorial({VoidCallback? onFinish}) =>
    createTutorial(
      targets: inventoryTargets,
      onFinish: onFinish,
    );

TutorialCoachMark getChecklistTutorial({VoidCallback? onFinish}) =>
    createTutorial(
      targets: checklistTargets,
      onFinish: onFinish,
    );

TutorialCoachMark getProfileTutorial({VoidCallback? onFinish}) =>
    createTutorial(
      targets: profileTargets,
      onFinish: onFinish,
    );

TutorialCoachMark createTutorial(
    {required List<TargetFocus> targets, VoidCallback? onFinish}) {
  return TutorialCoachMark(
    targets: targets,
    colorShadow: AppColors.lightGreyColor.withAlpha(256),
    onFinish: onFinish,
  );
}

TargetFocus createTargetFocus(
    {required GlobalKey key,
    required List<TargetContent> contents,
    bool enableTargetTab = true}) {
  return TargetFocus(
    keyTarget: key,
    enableTargetTab: enableTargetTab,
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
    align: align,
    child: SizedBox(
      width: 500,
      child: DottedBorder(
        color: AppColors.whiteColor,
        strokeWidth: 2,
        radius: const Radius.circular(15),
        borderType: BorderType.RRect,
        padding: const EdgeInsets.all(10),
        dashPattern: const [8, 5, 8, 5],
        child: Text(
          text,
          style: textStyle16.copyWith(color: AppColors.whiteColor),
        ),
      ),
    ),
  );
}
