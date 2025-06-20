import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final List<Map<String, String>> onBoardList = [
    {
      'image': AppAssets.onBoard3,
      'title': 'Share the Shopping Share the Love',
      'subTitle':
          'Create & share lists instantly,track shopping \n progress, and link the items to top stores',
    },
    {
      'image': AppAssets.onBoard2,
      'title': 'Keep Track Of Your Fridge',
      'subTitle':
          'Track your fridge contents, never miss \n items, organize your way and use scan & go',
    },
    {
      'image': AppAssets.onBoard1,
      'title': 'Keep Your Receipts in Check',
      'subTitle':
          'Organize receipts with easy photos.\nTrack budget quickly & find purchases \n with ease',
    },
  ];

  int selectedPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      // appBar: AppBar(title:   Text(selectedPage.toString(),
      //   style: textStyle20SemiBold.copyWith(fontSize: 25),
      //
      //   textAlign: TextAlign.center,
      // ),),
      body: Column(
        children: [
          60.h.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${selectedPage + 1}/${onBoardList.length}",
                  style: textStyle12.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                    onTap: () {
                      // setState(() {
                      // _pageController.animateToPage(2,
                      //     duration: Duration(milliseconds: 500),
                      //     curve: Curves.easeIn);
                      // });

                      context.goNamed(AppRoute.nickNameScreen.name,
                          extra: false);
                    },
                    child: Text('Skip',
                        style: appBarTitleStyle.copyWith(
                            color: AppColors.orangeColor,
                            fontWeight: FontWeight.w400))),
              ],
            ),
          ),
          40.h.verticalSpace,
          Container(
            height: 40.h,
            width: 350.h,

            color: AppColors.whiteColor,
            child: Center(
                child: Image.asset(
              AppAssets.appLogo,
            )),
            //Image.asset("assets/images/profile.png")),
          ),
          50.h.verticalSpace,
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              itemCount: onBoardList.length,
              onPageChanged: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
              itemBuilder: (context, index) =>
                  _buildOnBoardCard(onBoardList[index]),
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: onBoardList.length,
            effect: CustomizableEffect(
              spacing: 0,
              dotDecoration: DotDecoration(
                width: 28.w,
                height: 5.h,
                color: AppColors.greyColor.withOpacity(0.6),
              ),
              activeDotDecoration: DotDecoration(
                width: 28.w,
                height: 5.h,
                color: AppColors.blackColor,
              ),
            ),
          ),
          50.h.verticalSpace,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppButton(
              onPressed: () {
                if (selectedPage == onBoardList.length - 1) {
                  context.goNamed(AppRoute.nickNameScreen.name, extra: false);
                } else {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              text: selectedPage == (onBoardList.length - 1)
                  ? 'Get Started'
                  : 'Next',
            ),
          ),
          20.h.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildOnBoardCard(Map<String, dynamic> onBoardDetails) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        children: [
          //  const Placeholder(),

          ElasticInRight(
            child: Container(
              height: 250.h,
              width: 450.h,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  image: DecorationImage(
                image: AssetImage(
                  onBoardDetails['image'].toString(),
                ),
              )),
            ),
          ),
          30.h.verticalSpace,
          Text(
            onBoardDetails['title'],
            style: appBarTitleStyle.copyWith(
                fontWeight: FontWeight.w800, fontSize: 22.sp),
            textAlign: TextAlign.center,
          ),
          25.h.verticalSpace,
          Text(
            onBoardDetails['subTitle'],
            style: textStyle14.copyWith(
                color: Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
