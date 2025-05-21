import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/screens/progress_screen/progress_screen.dart';
import 'package:canadian_citizenship/services/notification_servive.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget>? screens;

  void onTap() {
    setState(() {
      selectedIndex = 2;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();

    // Initialize screens list after the instance is created
    screens = [
      HomeScreen(),
      GlossaryScreen(),
      AllMockTestScreen(),
      ProgressScreen(
        onTap: () => onTap(),
      ),
      SettingsScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setNotifications();
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification permission granted');
      } else {
        print('Notification permission denied');
      }
    } else {
      print('Notification permission already granted');
    }
  }

  Future<void> setNotifications() async {
    NotificationService.cancelAllNotification();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens![selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(.1),
                  offset: Offset(0, 0),
                  blurRadius: 20,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, context.bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navBarItem(
                  icon: AppAssets.home,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                _navBarItem(
                  icon: AppAssets.glossary,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                _navBarItem(
                  icon: AppAssets.test,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
                _navBarItem(
                  icon: AppAssets.progress,
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                ),
                _navBarItem(
                  icon: AppAssets.settings,
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    setState(() {
                      selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBarItem({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        icon,
        width: context.responsiveSize(30),
        height: context.responsiveSize(30),
        color: isSelected ? AppColors.accent : AppColors.black.withOpacity(.5),
      ),
    );
  }
}
