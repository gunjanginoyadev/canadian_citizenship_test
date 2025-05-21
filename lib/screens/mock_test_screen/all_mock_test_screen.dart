import 'package:canadian_citizenship/core/widgets/premium_strip.dart';
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/mock_test_screen/test_screen.dart';
import 'package:canadian_citizenship/screens/premium_screen/premium_screen.dart';

class AllMockTestScreen extends StatefulWidget {
  const AllMockTestScreen({super.key});

  @override
  State<AllMockTestScreen> createState() => _AllMockTestScreenState();
}

class _AllMockTestScreenState extends State<AllMockTestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MockTestProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          context.local.mock_test,
          style: semiBold(context, fontSize: 18, color: AppColors.accent),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showPremiumScreenBottomSheet(
                context,
                onTap: () {},
                showAdOption: false,
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                gradient: AppColors.proGradient(),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.pro,
                    height: context.responsiveSize(20, min: 20),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    context.local.pro_cap,
                    style: medium(
                      context,
                      fontSize: 18,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PremiumStrip(),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(.06),
                          offset: Offset(0, 3),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<MockTestProvider>(
                          builder: (context, provider, _) {
                            return CircularPercentIndicator(
                              radius: context.responsiveSize(50),
                              lineWidth: 8,
                              progressColor: AppColors.accent,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent:
                                  provider.totalQuestions == 0
                                      ? 0
                                      : (provider.currentProgress /
                                          provider.totalQuestions),
                              center: Text(
                                "${provider.currentProgress == 0 ? 0 : ((provider.currentProgress / provider.totalQuestions) * 100).floor()}%",
                                style: medium(
                                  context,
                                  fontSize: 18,
                                  color: AppColors.black,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.local.test_progress,
                              style: semiBold(
                                context,
                                fontSize: 18,
                                color: AppColors.black,
                              ),
                            ),
                            Consumer<MockTestProvider>(
                              builder: (context, provider, _) {
                                return Text(
                                  "${provider.currentProgress == 0 ? 0 : ((provider.currentProgress / provider.totalQuestions) * 100).floor()}% ${context.local.progress}",
                                  style: medium(
                                    context,
                                    fontSize: 16,
                                    color: AppColors.black.withOpacity(.5),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<MockTestProvider>(
                      builder: (context, provider, _) {
                        return provider.isDataLoaded
                            ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                itemBuilder:
                                    (context, index) => _mockTestCard(
                                      onTap: () {
                                        if (index != 0) {
                                          showPremiumScreenBottomSheet(
                                            context,
                                            onTap: () {
                                              Navigator.pop(context);

                                              adsController.showRewardedAd(
                                                context,
                                                onRewardGranted: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => TestScreen(
                                                            questions:
                                                                provider
                                                                    .mockTestData[index],
                                                          ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            showAdOption: true,
                                          );
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => TestScreen(
                                                  questions:
                                                      provider
                                                          .mockTestData[index],
                                                ),
                                          ),
                                        );
                                      },
                                      isPremiumOnly: index != 0,
                                      title:
                                          "${context.local.mock_test} ${String.fromCharCode(65 + index)}",
                                      totalQuestions:
                                          provider.mockTestData[index].length
                                              .toString(),
                                    ),
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 15),
                                itemCount: provider.mockTestData.length,
                              ),
                            )
                            : Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accent,
                              ),
                            );
                      },
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

  _mockTestCard({
    required VoidCallback onTap,
    required bool isPremiumOnly,
    required String title,
    required String totalQuestions,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(.06),
              offset: Offset(0, 0), // 👈 No directional offset
              blurRadius: 18, // (optional) helps to make it more visible
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              children: [
                Container(
                  height: context.responsiveSize(50, min: 50),
                  width: context.responsiveSize(50, min: 50),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundDecoration:
                      isPremiumOnly
                          ? BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                          : null,
                  padding: EdgeInsets.all(context.responsiveSize(10)),
                  child: Image.asset(AppAssets.mockTestImage),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: semiBold(
                        context,
                        fontSize: 16,
                        color:
                            isPremiumOnly
                                ? AppColors.black.withOpacity(.5)
                                : AppColors.black.withOpacity(.6),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${totalQuestions} Questions",
                          style: regular(
                            context,
                            fontSize: 12,
                            color:
                                isPremiumOnly
                                    ? AppColors.black.withOpacity(.5)
                                    : AppColors.black.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (isPremiumOnly)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SvgPicture.asset(
                    AppAssets.lock,
                    height: context.responsiveSize(40, min: 40),
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
