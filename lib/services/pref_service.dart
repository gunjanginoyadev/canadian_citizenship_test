import 'package:canadian_citizenship/libs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  PrefService._();

  static late SharedPreferences _prefs;

  static int testNotificationId = 1;
  static int dailyPracticeNotificationId = 2;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool isRminderOn() {
    return _prefs.getBool("is_reminder_on") ?? true;
  }

  static void setIsRminderOn(bool value) {
    _prefs.setBool("is_reminder_on", value);
  }

  static void saveTestDate(String date) {
    _prefs.setString('test_date', date);
  }

  static String? getTestDate() {
    return _prefs.getString('test_date');
  }

  static Future<void> increaseProgress(
    int categoryIndex,
    String chapterId,
  ) async {
    List<String> currentList = _prefs.getStringList("progress") ?? [];

    if (!currentList.contains(chapterId)) {
      currentList.add(chapterId);
      await _prefs.setStringList("progress", currentList);
    }
    await increaseCategoryProgress(categoryIndex, chapterId);
  }

  static Future<void> increaseTestProgress(String index) async {
    List<String> currentList = _prefs.getStringList("test_progress") ?? [];

    if (!currentList.contains(index)) {
      currentList.add(index);
      await _prefs.setStringList("test_progress", currentList);
    }
  }

  static Future<void> increaseCategoryProgress(
    int index,
    String lessonIndex,
  ) async {
    List<String> currentList =
        _prefs.getStringList("category_progress_$index") ?? [];

    if (!currentList.contains(lessonIndex.toString())) {
      currentList.add(lessonIndex.toString());
      await _prefs.setStringList("category_progress_$index", currentList);
    }
  }

  static int getCategoryProgress(int index) {
    List<String> currentList =
        _prefs.getStringList("category_progress_$index") ?? [];
    return currentList.length;
  }

  /// Get number of chapters completed (i.e., progress count)
  static int getProgress() {
    List<String> currentList = _prefs.getStringList("progress") ?? [];
    return currentList.length;
  }

  static int getTestProgress() {
    List<String> currentList = _prefs.getStringList("test_progress") ?? [];
    print(" --- Test Progress: ${currentList.length}");
    return currentList.length;
  }

  static Future<void> saveLastLesionCategory(int index) async {
    await _prefs.setInt('last_lesion_category', index);
  }

  static int getLastLesionCategory() {
    return _prefs.getInt('last_lesion_category') ?? 0;
  }

  static Future<void> saveLastLesion(int index) async {
    await _prefs.setInt('last_lesion', index);
  }

  static Future<void> clearLastSavedLesion() async {
    await _prefs.remove("last_lesion");
  }

  static int? getLastLesion() {
    return _prefs.getInt('last_lesion');
  }

  static bool isFirstTime() {
    return _prefs.getBool('is_first_time') ?? true;
  }

  static void setFirstTime() {
    _prefs.setBool('is_first_time', false);
  }

  /// Clears all progress including main progress and all category progress.
  static Future<void> clearAllProgress() async {
    // Clear the main progress list
    await _prefs.remove('progress');

    // Optionally clear the last lesion and last category
    await _prefs.remove('last_lesion_category');
    await _prefs.remove('last_lesion');

    // Clear all category progress keys dynamically
    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('category_progress_')) {
        await _prefs.remove(key);
      }
    }
  }

  /// Clears entire SharedPreferences except 'test_date'.
  static Future<void> clearAllExceptTestDate() async {
    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key != 'test_date' && key != 'is_first_time') {
        await _prefs.remove(key);
      }
    }
  }

  static String getSelectedLanguage() {
    return _prefs.getString('saved_language') ?? 'en';
  }

  static Future<void> saveSelectedLanguage(String language) async {
    _prefs.setString('saved_language', language);
  }

  static Future<void> savePracticeTime(TimeOfDay time) async {
    // Store as minutes since midnight for easy conversion
    final minutes = time.hour * 60 + time.minute;
    await _prefs.setInt('practice_time_minutes', minutes);
  }

  static TimeOfDay getPracticeTime() {
    // Default to 8:00 AM if not set
    final minutes =
        _prefs.getInt('practice_time_minutes') ??
        480; // Default: 8:00 AM (8*60)
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  static List<int> getTestScoreHistory() {
    List<String> list = _prefs.getStringList("test_score_history") ?? [];
    return list.map((e) => int.parse(e)).toList();
  }

  static Future<void> addTestHistoryScore(int score) async {
    List<String> list = _prefs.getStringList("test_score_history") ?? [];
    List<String> newList = [];
    newList.addAll(list);
    newList.add(score.toString());
    await _prefs.setStringList("test_score_history", newList);
  }
}
