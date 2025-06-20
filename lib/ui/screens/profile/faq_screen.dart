import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/faq_model.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/extensions/context_ext.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late ProfileProvider provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<ProfileProvider>().getFaqs();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: GlobalText('FAQ', textStyle: textStyle24SemiBold),
      ),
      body: Column(
        children: [
          Container(
            height: 90.h,
            alignment: Alignment.center,
            color: AppColors.primaryColor.withAlpha(50),
            child: GlobalText(
              "Frequently Asked Questions",
              textStyle:
                  textStyle24SemiBold.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          20.h.verticalSpace,
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.faqs.isEmpty
                    ? GlobalText(
                        'No FAQs.',
                        textStyle: textStyle16,
                      )
                    : ListView.builder(
                        itemCount: provider.faqs.length,
                        itemBuilder: (context, index) {
                          return _buildExpansionTile(provider.faqs[index]);
                        },
                      ),
          ),
          if (!provider.isLoading && provider.faqs.isNotEmpty) ...[
            TextButton(
              onPressed: () async {
                if (!await launchUrl(
                    Uri.parse('https://www.shopeaseapp.com/faq'))) {
                  if (!context.mounted) return;
                  context.showErrorMessage('Something went wrong.');
                }
              },
              child: GlobalText(
                "See More FAQ's",
                textStyle: textStyle18.copyWith(color: AppColors.orangeColor),
              ),
            ),
            20.h.verticalSpace,
          ]
        ],
      ),
    );
  }

  Widget _buildExpansionTile(FaqModel faq) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      controlAffinity: ListTileControlAffinity.leading,
      collapsedIconColor: AppColors.orangeColor,
      iconColor: AppColors.orangeColor,
      expandedAlignment: Alignment.centerLeft,
      shape: const RoundedRectangleBorder(),
      title: GlobalText(faq.question, textStyle: textStyle16),
      children: [
        GlobalText(faq.answer, textStyle: textStyle14),
      ],
    );
  }
}
