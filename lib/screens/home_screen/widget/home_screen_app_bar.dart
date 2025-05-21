import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/premium_screen/premium_screen.dart';

import '../../../libs.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.local.welcome_there,
                style: semiBold(context, fontSize: 20),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showPremiumScreenBottomSheet(
              context,
              onTap: () {},
              showAdOption: false,
            );
          },
          child: Container(
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
                  style: medium(context, fontSize: 18, color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
