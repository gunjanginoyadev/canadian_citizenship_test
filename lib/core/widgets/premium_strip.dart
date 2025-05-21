import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/premium_screen/premium_screen.dart';

class PremiumStrip extends StatelessWidget {
  const PremiumStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPremiumScreenBottomSheet(
          context,
          onTap: () {},
          showAdOption: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.secondary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                context.local.unlock_all_premium_features,
                style: semiBold(context, fontSize: 16, color: AppColors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                context.local.details,
                style: semiBold(
                  context,
                  fontSize: 12,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
