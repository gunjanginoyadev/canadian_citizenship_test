import 'package:canadian_citizenship/main.dart';

import '../../../libs.dart';

class ContinueStudyingCard extends StatelessWidget {
  final VoidCallback onTap;
  const ContinueStudyingCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AppAssets.continueStudyingCardBg),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<HomeScreenProvider>(
                  builder: (context, provider, _) {
                    return Text(
                      provider.nextTestDate,
                      style: regular(
                        context,
                        fontSize: 16,
                        color: AppColors.white.withOpacity(.7),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 3),
                Consumer<HomeScreenProvider>(
                  builder: (context, provider, _) {
                    return provider.dataLoaded
                        ? Text(
                          "${((provider.currentProgress / (provider.allLessonsData.length)) * 100).floor()}% ${context.local.progress}",
                          style: semiBold(
                            context,
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        )
                        : const SizedBox();
                  },
                ),
                const SizedBox(height: 3),
                Text(
                  context.local.your_test_date_has_passed,
                  style: regular(
                    context,
                    fontSize: 14,
                    color: AppColors.white.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffF7D7D9).withOpacity(.30),
                    const Color(0xffFFE9EA).withOpacity(.20),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(color: AppColors.white, width: .6),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                context.local.continue_studying,
                style: semiBold(context, fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
