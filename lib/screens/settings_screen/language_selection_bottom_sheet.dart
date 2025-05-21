import 'package:canadian_citizenship/core/constants/app_colors.dart';
import 'package:canadian_citizenship/core/constants/text_style.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const LanguageBottomSheet({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String selectedLanguage;

  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Indonesian', 'code': 'id'},
    {'name': 'Japanese', 'code': 'ja'},
    {'name': 'Portuguese', 'code': 'pt'},
    {'name': 'Russian', 'code': 'ru'},
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'Vietnamese', 'code': 'vi'},
    {'name': 'Chinese', 'code': 'zh'},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: languages.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = language['code'] == selectedLanguage;
                return _buildLanguageItem(context, language, isSelected);
              },
            ),
          ),
          const SizedBox(height: 15),
          _buildApplyButton(context),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      height: 4,
      width: 40,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Text(
            context.local.language,
            style: semiBold(context, fontSize: 18, color: AppColors.accent),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.black.withOpacity(0.05),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                size: 20,
                color: AppColors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    Map<String, dynamic> language,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = language['code'];
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.accent
                    : AppColors.black.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected
                  ? AppColors.accent.withOpacity(0.1)
                  : Colors.transparent,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Text(
              language['name'],
              style: medium(
                context,
                fontSize: 14,
                color: isSelected ? AppColors.accent : AppColors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          widget.onLanguageSelected(selectedLanguage);
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: double.infinity,
          child: Center(
            child: Text(
              context.local.submit,
              style: semiBold(context, fontSize: 14, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// Function to show language bottom sheet
void showLanguageBottomSheet(
  BuildContext context, {
  required String currentLanguage,
  required Function(String) onLanguageSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => LanguageBottomSheet(
          currentLanguage: currentLanguage,
          onLanguageSelected: onLanguageSelected,
        ),
  );
}
