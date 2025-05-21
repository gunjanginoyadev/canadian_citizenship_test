import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/date_selection_screen/date_selection_screen.dart';
import 'package:canadian_citizenship/screens/html_content_from_file_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        "image": "assets/images/onboarding_image_0.png",
        "title": context.local.onboarding_one_title,
        "desc": context.local.onboarding_one_desc,
      },
      {
        "image": "assets/images/onboarding_image_1.png",
        "title": context.local.onboarding_two_title,
        "desc": context.local.onboarding_two_desc,
      },
      {
        "image": "assets/images/onboarding_image_2.png",
        "title": context.local.onboarding_three_title,
        "desc": context.local.onboarding_three_desc,
      },
      {
        "image": "assets/images/onboarding_image_3.png",
        "title": context.local.onboarding_four_title,
        "desc": context.local.onboarding_four_desc,
      },
      {
        "image": "assets/images/onboarding_image_4.png",
        "title": context.local.onboarding_five_title,
        "desc": context.local.onboarding_five_desc,
      },
    ];

    return Container(
      height: context.screenHeight,
      width: context.screenWidth,
      decoration: BoxDecoration(gradient: AppColors.onboardingGradient()),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            fit: BoxFit.cover,
            AppAssets.onboardingBgShape,
            height: context.screenHeight * .7,
            width: context.screenWidth,
          ),
          Scaffold(
            backgroundColor: AppColors.transparent,
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: context.responsiveSize(100),
              title: DotsIndicator(
                dotsCount: 5,
                position: currentIndex.toDouble(),
                decorator: DotsDecorator(
                  color: const Color(0xffD87B80), // Inactive color
                  activeColor: AppColors.accent,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDateSelectionScreen(),
                          ),
                        ),
                    child: Text(
                      context.local.skip_with_space,
                      style: semiBold(
                        context,
                        fontSize: 18,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Expanded(child: Image.asset(data[currentIndex]["image"])),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      context.bottomPadding,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          data[currentIndex]["title"],
                          textAlign: TextAlign.center,
                          style: semiBold(context),
                        ),
                        Text(
                          data[currentIndex]["desc"],
                          textAlign: TextAlign.center,
                          style: regular(context, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (currentIndex >= data.length - 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TestDateSelectionScreen(),
                                ),
                              );
                            } else {
                              currentIndex++;
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: context.responsiveSize(200),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              context.local.next_with_space,
                              style: semiBold(
                                context,
                                fontSize: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "${context.local.by_continuing_you} ${context.local.agree_to_out_privacy_policy.trim().split(" ")[0]} ${context.local.agree_to_out_privacy_policy.trim().split(" ")[1]} ${context.local.agree_to_out_privacy_policy.trim().split(" ")[2]}",
                              style: regular(context, fontSize: 12),
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
                                " ${context.local.privacy_policy} ",
                                style: regular(
                                  context,
                                  fontSize: 12,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            Text(
                              "${context.local.and.trim()} ",
                              style: regular(context, fontSize: 12),
                            ),
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
                                style: regular(
                                  context,
                                  fontSize: 12,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
