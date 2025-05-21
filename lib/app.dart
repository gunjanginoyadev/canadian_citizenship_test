import 'libs.dart';

class CanadianCitizenshipTest extends StatefulWidget {
  const CanadianCitizenshipTest({super.key});

  @override
  State<CanadianCitizenshipTest> createState() =>
      _CanadianCitizenshipTestState();
}

class _CanadianCitizenshipTestState extends State<CanadianCitizenshipTest> {
  @override
  void initState() {
    super.initState();
    startTimeAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.screenHeight,
        width: context.screenWidth,
        decoration: BoxDecoration(gradient: AppColors.onboardingGradient()),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(AppAssets.splashBgShape),
            Image.asset(
              AppAssets.canadianLeaf,
              height: context.responsiveSize(150, max: 300),
            ),
          ],
        ),
      ),
    );
  }

  void startTimeAndNavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  PrefService.isFirstTime()
                      ? const OnboardingScreen()
                      : const MainScreen(),
        ),
        // MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }
}
