import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/services/notification_servive.dart';
import 'package:table_calendar/table_calendar.dart';

class TestDateSelectionScreen extends StatefulWidget {
  const TestDateSelectionScreen({super.key});

  @override
  State<TestDateSelectionScreen> createState() =>
      _TestDateSelectionScreenState();
}

class _TestDateSelectionScreenState extends State<TestDateSelectionScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0C0C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(AppAssets.canadianLeaf, height: 100),
            const SizedBox(height: 20),
            Text(
              context.local.when_is_your_test,
              style: semiBold(context, fontSize: 18, color: AppColors.white),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                context.local.when_is_your_test_desc,
                textAlign: TextAlign.center,
                style: regular(context, fontSize: 12, color: AppColors.white),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCalendarCard(context),
                      const SizedBox(height: 20),
                      _buildButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime(2100),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate:
          (day) => isSameDay((_selectedDay ?? DateTime.now()), day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.red),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.red),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            PrefService.saveTestDate(
              _selectedDay == null
                  ? DateTime.now().toString()
                  : _selectedDay!.toString(),
            );
            NotificationService.cancelAllNotification();
            await NotificationService.scheduleNotification(
              scheduledNotificationDateTime: _selectedDay ?? DateTime.now(),
              id: PrefService.testNotificationId,
              body: "Todays is your test day",
            );
            await NotificationService.scheduleDailyNotification(
              id: PrefService.dailyPracticeNotificationId,
              title: "Daily Practice Reminder",
              body: "Time to practice for your citizenship test!",
              time: PrefService.getPracticeTime(), // 8:00 AM
            );

            PrefService.setFirstTime();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              context.local.select_cap,
              style: semiBold(context, fontSize: 16, color: AppColors.white),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              context.local.skip_cap,
              style: semiBold(context, fontSize: 16, color: AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }
}
