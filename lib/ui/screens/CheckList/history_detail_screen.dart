import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/checklist_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen(
      {super.key, required this.invoice, required this.count});

  final Map<String, dynamic> invoice;
  final int count;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
          title: GlobalText(
            " ${widget.invoice['products']}  Products ",
            textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GlobalText(
                    'Today',
                    textStyle: textStyle16.copyWith(
                        fontSize: 14, overflow: TextOverflow.ellipsis),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlobalText(
                        widget.invoice['shop'],
                        maxLine: 3,
                        textStyle: textStyle16.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            decorationColor: AppColors.orangeColor,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.orangeColor,
                            fontWeight: FontWeight.w600),
                      ),
                      GlobalText(
                        '\$${widget.invoice['total']}',
                        textStyle: textStyle16.copyWith(
                            fontSize: 20, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                _buildCurrentListView(provider, widget.count),
              ]),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: AppButton(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 15.sp),
                child: SvgIcon(
                  AppAssets.checkList,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                context.goNamed(AppRoute.checkList.name);

                provider.deleteFromHistory(widget.invoice);
              },
              text: 'Add to Checklist'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }

  Widget _buildCurrentListView(ChecklistProvider provider, int count) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: provider.checklist
              .take(count)
              .map(
                (e) => ChecklistTile(
                  product: e,
                  onDelete: () {
                    provider.deleteProduct(e.itemId!);
                  },
                  isSlideEnabled: true,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
