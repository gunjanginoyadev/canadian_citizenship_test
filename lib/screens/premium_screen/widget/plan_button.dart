import 'package:canadian_citizenship/core/constants/app_colors.dart';
import 'package:canadian_citizenship/core/constants/text_style.dart';
import 'package:flutter/widgets.dart';

class PlanButton extends StatelessWidget {
  final String title;
  final String price;
  final String realPrice;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanButton({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
    this.realPrice = "",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/plan_button_bg.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color:
                isSelected ? AppColors.accent : AppColors.accent.withOpacity(.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: semiBold(context, fontSize: 14, color: AppColors.black),
                ),
                Row(
                  children: [
                    if (realPrice.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          realPrice,
                          style: medium(
                            context,
                            fontSize: 12,
                            color: AppColors.secondary,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    Text(
                      price,
                      style: semiBold(
                        context,
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
