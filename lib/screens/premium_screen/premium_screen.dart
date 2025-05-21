import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/html_content_from_file_screen.dart';
import 'package:canadian_citizenship/screens/premium_screen/widget/plan_button.dart';

class PremiumScreenBottomSheet extends StatefulWidget {
  final VoidCallback onTap;
  final bool showAdOption;

  const PremiumScreenBottomSheet({
    super.key,
    required this.onTap,
    required this.showAdOption,
  });

  @override
  State<PremiumScreenBottomSheet> createState() =>
      _PremiumScreenBottomSheetState();
}

class _PremiumScreenBottomSheetState extends State<PremiumScreenBottomSheet> {
  int selectedPlan = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Add this to ensure proper sizing
                children: [
                  Container(
                    height: context.responsiveSize(250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),

                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/premium_screen_bg.jpeg",
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.white.withOpacity(0),
                                AppColors.white,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              AppAssets.close,
                              color: AppColors.white,
                              height: context.responsiveSize(25),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.local.pass_the_first_time,
                              style: semiBold(context, fontSize: 18),
                            ),
                            Text(
                              context.local.upgrade_now_to_gain_full_access,
                              textAlign: TextAlign.center,
                              style: medium(
                                context,
                                fontSize: 14,
                                color: AppColors.black.withOpacity(.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.secondary, width: .5),
                    ),
                    padding: const EdgeInsets.all(
                      12,
                    ), // Add const for optimization
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _premiumFeature(
                          context,
                          context.local.unlimited_access_to_all_chapters,
                        ),
                        const SizedBox(height: 12),
                        _premiumFeature(
                          context,
                          context.local.unlimited_access_to_practice_tests,
                        ),
                        const SizedBox(height: 12),
                        _premiumFeature(
                          context,
                          context.local.listen_to_all_lessons,
                        ),
                        const SizedBox(height: 12),
                        _premiumFeature(
                          context,
                          context.local.lessons_and_questions,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        PlanButton(
                          onTap: () {
                            setState(() {
                              selectedPlan = 0;
                            });
                          },
                          title: "Weekly Subscription",
                          price: "₹140.00/week",
                          realPrice: "₹186.99",
                          isSelected: selectedPlan == 0,
                        ),
                        const SizedBox(height: 15),
                        PlanButton(
                          onTap: () {
                            setState(() {
                              selectedPlan = 1;
                            });
                          },
                          title: "Monthly Subscription",
                          price: "₹140.00/week",
                          isSelected: selectedPlan == 1,
                        ),
                        const SizedBox(height: 15),
                        PlanButton(
                          onTap: () {
                            setState(() {
                              selectedPlan = 2;
                            });
                          },
                          title: "Lifetime Access",
                          price: "₹720.00/week",
                          realPrice: "₹1107.99",
                          isSelected: selectedPlan == 2,
                        ),
                      ],
                    ),
                  ),
                  if (widget.showAdOption) const SizedBox(height: 15),
                  if (widget.showAdOption)
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppAssets.watchAdsCardBg),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      context.local.ad,
                                      style: semiBold(
                                        context,
                                        fontSize: 12,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.watchAds,
                                    height: context.responsiveSize(50, min: 50),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    // Added Expanded here to prevent overflow
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${context.local.watch_an_ad_instead} ",
                                          style: semiBold(
                                            context,
                                            fontSize: 14,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        Text(
                                          context
                                              .local
                                              .unlock_this_test_for_free,
                                          style: regular(
                                            context,
                                            fontSize: 12,
                                            color: AppColors.white.withOpacity(
                                              .7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => HtmlContentFromFileScreen(
                        filePath: "assets/data/refund_policy.html",
                      ),
                ),
              );
            },
            child: Text(
              context.local.refund_policy,
              style: semiBold(context, fontSize: 18, color: AppColors.accent),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.white, width: 0.5),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              context.local.continue_studying.split(" ").first.trim(),
              style: medium(context, fontSize: 18, color: AppColors.white),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            context.local.restore,
            style: semiBold(context, fontSize: 18, color: AppColors.accent),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => HtmlContentFromFileScreen(
                              filePath: "assets/data/terms.html",
                            ),
                      ),
                    );
                  },
                  child: Text(
                    context.local.terms_of_service,
                    style: medium(
                      context,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => HtmlContentFromFileScreen(
                              filePath: "assets/data/privacy_policy.html",
                            ),
                      ),
                    );
                  },
                  child: Text(
                    context.local.privacy_policy,
                    style: medium(
                      context,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.bottomPadding),
        ],
      ),
    );
  }

  Widget _premiumFeature(BuildContext context, String text) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: AppColors.accent,
          size: context.responsiveSize(25),
        ),
        const SizedBox(width: 15),
        Flexible(child: Text(text, style: medium(context, fontSize: 16))),
      ],
    );
  }
}

void showPremiumScreenBottomSheet(
  BuildContext context, {
  required VoidCallback onTap,
  required bool showAdOption,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight: context.screenHeight * 0.9,
      maxWidth: context.screenWidth,
    ),
    builder:
        (context) =>
            PremiumScreenBottomSheet(onTap: onTap, showAdOption: showAdOption),
  );
}
