import 'package:canadian_citizenship/main.dart';

import '../../../libs.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChange;
 
  const SearchBox({
    super.key,
    required this.controller,
    required this.focusNode, required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.black.withOpacity(.3)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.search,
            height: context.responsiveSize(24, min: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChange,
              style: regular(context, fontSize: 16),
              cursorColor: AppColors.black,
              decoration: InputDecoration.collapsed(
                hintText: context.local.search,
                hintStyle: regular(
                  context,
                  fontSize: 16,
                  color: AppColors.black.withOpacity(.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
