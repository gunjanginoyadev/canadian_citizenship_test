import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/html_content_from_file_screen.dart';
import 'package:canadian_citizenship/screens/settings_screen/language_selection_bottom_sheet.dart';
import 'package:canadian_citizenship/services/notification_servive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// Replace with your actual imports
import '../../libs.dart';
import 'package:canadian_citizenship/screens/premium_screen/premium_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hapticFeedback = false;
  late TimeOfDay _practiceTime;

  @override
  void initState() {
    super.initState();
    _practiceTime = PrefService.getPracticeTime();
    hapticFeedback = PrefService.isRminderOn();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      Provider.of<HomeScreenProvider>(
        context,
        listen: false,
      ).selectTestDate(picked);
      if (!hapticFeedback) {
        setState(() {});

        return;
      }

      NotificationService.cancelNotification(PrefService.testNotificationId);
      NotificationService.scheduleNotification(
        scheduledNotificationDateTime: picked,
        id: PrefService.testNotificationId,
        body: "Todays is your test day",
      );
      setState(() {});
    }
  }

  // Replace with your actual package name
  final String packageName = "";

  void _launchRateApp() async {
    final Uri url = Uri.parse(
      "https://play.google.com/store/apps/details?id=$packageName",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  void _shareApp() {
    final String appUrl =
        "https://play.google.com/store/apps/details?id=$packageName";
    Share.share("Check out this awesome app: $appUrl");
  }

  Future<void> _pickTime() async {
    final TimeOfDay initialTime = PrefService.getPracticeTime();

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.accent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _practiceTime = picked;
      PrefService.savePracticeTime(picked);

      NotificationService.cancelNotification(
        PrefService.dailyPracticeNotificationId,
      );
      if (!hapticFeedback) {
        setState(() {});

        return;
      }
      await NotificationService.scheduleDailyNotification(
        id: PrefService.dailyPracticeNotificationId,
        title: "Daily reminder",
        body: "it's time for the practice test",
        time: picked,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          context.local.settings,
          style: semiBold(context, color: AppColors.accent, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, context.bottomPadding),
        child: ListView(
          children: [
            _buildPremiumBanner(context),
            const SizedBox(height: 20),
            _buildSettingsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: () {
          showPremiumScreenBottomSheet(
            context,
            onTap: () {},
            showAdOption: false,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/premium_banner_bg.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssets.pro,
                height: context.responsiveSize(70),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  context.local.upgrade_to_premium,
                  style: semiBold(
                    context,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _defaultCardDecoration(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, context.local.reminder),
          const SizedBox(height: 10),
          _switchTile(context, context.local.reminder, hapticFeedback, (
            value,
          ) async {
            hapticFeedback = value;
            PrefService.setIsRminderOn(value);
            setState(() {});
            if (hapticFeedback) {
              await NotificationService.scheduleNotification(
                scheduledNotificationDateTime: DateTime.parse(
                  PrefService.getTestDate() ?? DateTime.now().toString(),
                ),
                id: PrefService.testNotificationId,
                body: "Todays is your test day",
              );
              await NotificationService.scheduleDailyNotification(
                id: PrefService.dailyPracticeNotificationId,
                title: "Daily Practice Reminder",
                body: "Time to practice for your citizenship test!",
                time: PrefService.getPracticeTime(), // 8:00 AM
              );
            } else {
              NotificationService.cancelAllNotification();
            }
          }),
          const SizedBox(height: 10),
          Consumer<HomeScreenProvider>(
            builder: (context, provider, _) {
              return _labeledPicker(
                context,
                context.local.test_date,
                provider.nextTestDate,
                AppAssets.calender,
                onTap: _pickDate,
              );
            },
          ),
          const SizedBox(height: 10),
          _labeledPicker(
            context,
            "",
            "${context.local.daily_practice_time}: ${_formatTimeOfDay(_practiceTime)}",
            AppAssets.clock, // You may need to add this asset
            onTap: _pickTime,
          ),

          const SizedBox(height: 20),
          _sectionTitle(context, context.local.other),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.rate,
            text: context.local.rate_us,
            onTap: _launchRateApp,
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.share,
            text: context.local.share_app,
            onTap: _shareApp,
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.privacy,
            text: context.local.privacy_policy,
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
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.terms,
            text: context.local.terms_and_conditions,
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
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.refundPolicy,
            text: context.local.refund_policy,
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
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.language,
            text: context.local.language,
            onTap: () {
              showLanguageBottomSheet(
                context,
                currentLanguage: PrefService.getSelectedLanguage(),
                onLanguageSelected: (value) async {
                  print(" --- language: $value");
                  selectedLanguage.value = value;
                  await PrefService.saveSelectedLanguage(value);
                },
              );
            },
          ),
          const SizedBox(height: 10),
          _settingTile(
            context,
            icon: AppAssets.moreApps,
            text: context.local.canada_jobs,
            onTap: () async {
              if (!await launchUrl(Uri.parse("https://canadianjobbank.org/"))) {
                throw Exception(
                  'Could not launch https://canadianjobbank.org/',
                );
              }
            },
          ),
          const SizedBox(height: 50),
          _sendFeedbackButton(
            context,
            text: context.local.clear_progress,
            onTap: () {
              showClearProgressDialog(context);
            },
          ),
          // const SizedBox(height: 10),
          // _sendFeedbackButton(context, text: context.local.send_feedback),
        ],
      ),
    );
  }

  Widget _labeledPicker(
    BuildContext context,
    String label,
    String value,
    String assetPath, {
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: _pickerBoxDecoration(),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: semiBold(
                    context,
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ),
                SvgPicture.asset(assetPath, height: context.responsiveSize(30)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingTile(
    BuildContext context, {
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: _pickerBoxDecoration(),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, height: context.responsiveSize(25)),
            const SizedBox(width: 10),
            Text(
              text,
              style: semiBold(context, fontSize: 12, color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      decoration: _pickerBoxDecoration(),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: semiBold(context, fontSize: 12, color: AppColors.black),
          ),
          SizedBox(
            height: 30,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.white,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.black.withOpacity(.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: regular(
        context,
        fontSize: 12,
        color: AppColors.black.withOpacity(.5),
      ),
    );
  }

  Widget _sendFeedbackButton(
    BuildContext context, {
    String text = "Send Feedback",
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            showFeedbackDialog(context);
          },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Center(
          child: Text(
            text,
            style: semiBold(context, fontSize: 12, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  BoxDecoration _defaultCardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(.06),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  BoxDecoration _pickerBoxDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.black.withOpacity(.3)),
  );

  void showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.primary,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.secondary,
                        size: context.responsiveSize(30),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.local.feedback_dialog_desc,
                          style: regular(
                            context,
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: context.local.write_your_feedback,
                      hintStyle: regular(
                        context,
                        fontSize: 12,
                        color: AppColors.black.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.black.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: regular(
                      context,
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Feedback submitted! Thank you."),
                          backgroundColor: AppColors.accent,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Center(
                        child: Text(
                          context.local.submit,
                          style: semiBold(
                            context,
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showClearProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.secondary,
                      size: context.responsiveSize(30),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.local.are_you_sure_you_want_to_clear,
                        style: medium(
                          context,
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              context.local.cancel,
                              style: semiBold(
                                context,
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await PrefService.clearAllExceptTestDate();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              context.local.clear,
                              style: semiBold(
                                context,
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this helper method to format the time
  String _formatTimeOfDay(TimeOfDay time) {
    // Format time as 12-hour with AM/PM
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
