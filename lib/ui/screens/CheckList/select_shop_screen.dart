import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_icon_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/shop_tile.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({super.key});

  @override
  State<SelectShopScreen> createState() => _SelectShopScreenState();
}

class _SelectShopScreenState extends State<SelectShopScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shop'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const SvgIcon(
                AppAssets.search,
                size: 24,
                color: AppColors.blackGreyColor,
              )),
          AppIconButton(
              onTap: _showAddShopSheet,
              child: const SvgIcon(
                AppAssets.add,
                size: 23,
                color: AppColors.orangeColor,
              ))
        ],
      ),
      body: Consumer<ChecklistProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Row(
                children: [
                  Text('${provider.shops.length} Products'),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: SvgIcon(
                        AppAssets.filterIcon,
                        size: 20.r,
                        color: AppColors.blackColor,
                      ))
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: provider.shops.indexed
                    .map(
                      (e) => ShopTile(
                        shop: e.$2,
                        onTap: () {
                          provider.changeSelectedShop(e.$1);
                        },
                        isSelected: provider.selectedShopIndex == e.$1,
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        );
      }),
    );
  }

  _showAddShopSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints.loose(Size(double.infinity, 0.6.sh)),
      context: context,
      builder: (context) => Consumer<ChecklistProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                GlobalText('Create New Shop', textStyle: textStyle18SemiBold),
                30.h.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: '*',
                      style: const TextStyle(color: Colors.red, fontSize: 17),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Shop Name',
                          style: textStyle16.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                AppTextField(
                  name: 'name',
                  controller: _nameController,
                ),
                20.h.verticalSpace,
                AppTextField(
                  name: 'location',
                  controller: _locationController,
                  labelText: 'Location',
                ),
                60.h.verticalSpace,
                AppButton(
                  onPressed: () {},
                  text: 'Create',
                  colorType: AppButtonColorType.primary,
                ),
                20.h.verticalSpace,
                AppButton(
                  onPressed: () {},
                  text: 'Cancel',
                  colorType: AppButtonColorType.secondary,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
