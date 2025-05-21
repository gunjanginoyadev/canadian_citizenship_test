import 'package:canadian_citizenship/libs.dart';
import 'package:intl/intl.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<LessonMain> allMainData = [];
  bool dataLoaded = false;
  String nextTestDate = "";
  int currentProgress = 0;
  List<Lesson> allLessonsData = [];

  Future<void> loadAllData() async {
    try {
      nextTestDate =
          PrefService.getTestDate() != null
              ? DateFormat(
                'd MMMM yyyy',
              ).format(DateTime.parse(PrefService.getTestDate()!))
              : "No test date set";

      dataLoaded = false;
      currentProgress = PrefService.getProgress();
      notifyListeners();

      String jsonFilePath = "assets/data/home_screen_data/main_content.json";
      String jsonString = await rootBundle.loadString(jsonFilePath);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      allMainData =
          (jsonData['main_content'] as List<dynamic>)
              .map((lesson) => LessonMain.fromJson(lesson))
              .toList();

      print(" --- all lessons data: ${allMainData.length}");

      await loadAllLessonsData();
    } catch (e) {
      print(" --- Error loading data: $e");
    } finally {
      dataLoaded = true;
      notifyListeners();
    }
  }

  // Future<void> loadAllData() async {
  //   nextTestDate =
  //       PrefService.getTestDate() != null
  //           ? DateFormat(
  //             'd MMMM yyyy',
  //           ).format(DateTime.parse(PrefService.getTestDate()!))
  //           : "No test date set";
  //   dataLoaded = false;
  //   currentProgress = PrefService.getProgress();
  //   notifyListeners();

  //   String jsonFilePath =
  //       "assets/data/home_screen_data/main_content.json"; // fixed comma in file name
  //   String jsonString = await rootBundle.loadString(jsonFilePath);
  //   Map<String, dynamic> jsonData =
  //       json.decode(jsonString) as Map<String, dynamic>;

  //   allLessonsData =
  //       (jsonData['main_content'] as List<dynamic>)
  //           .map((lesson) => Lesson.fromJson(lesson))
  //           .toList();

  //   print(" --- all lessons data: ${allLessonsData.length}");

  //   dataLoaded = true;
  //   notifyListeners();
  // }

  void selectTestDate(DateTime date) {
    nextTestDate = DateFormat('d MMMM yyyy').format(date);
    PrefService.saveTestDate(date.toString());
    notifyListeners();
  }

  Future<void> updateProgress(String categoryIndex ,String id) async {
    await PrefService.increaseProgress(int.parse(categoryIndex) ,id);
    currentProgress = PrefService.getProgress();
    notifyListeners();
  }

  List<Lesson> getCurrentCategoriesLessons(String index) {
  
    List<Lesson> lessons =
        allLessonsData.where((lesson) => lesson.chapter == int.parse(index)).toList();

    print(" --- lessons data: ${lessons.length}");
    return lessons;
  }

  Future<void> loadAllLessonsData() async {
    String jsonString = await rootBundle.loadString("assets/data/alldata.json");
    Map<String, dynamic> jsonData =
        json.decode(jsonString) as Map<String, dynamic>;

    allLessonsData =
        (jsonData['data']['content'] as List<dynamic>)
            .map((lesson) => Lesson.fromJson(lesson))
            .toList();

    print(" --- all lessons data: ${allLessonsData.length}");
  }

  int getCategoryProgress(int index, List<Lesson> lessons) {
  final progressList =
      PrefService.getCategoryProgress(index); // index starts from 1
  return progressList > lessons.length ? lessons.length : progressList;
}







  // Future<List<Lesson>> getCurrentCategoriesLessons(String title) async {
  //   String name = title.toLowerCase().replaceAll(" ", "_").replaceAll("'", "");
  //   print("--- file name: ${name}_data.json");
  //   String jsonFilePath =
  //       "assets/data/home_screen_data/${name}_data.json"; // fixed comma in file name
  //   String jsonString = await rootBundle.loadString(jsonFilePath);
  //   Map<String, dynamic> jsonData =
  //       json.decode(jsonString) as Map<String, dynamic>;

  //   List<Lesson> lessons =
  //       (jsonData['data'] as List<dynamic>)
  //           .map((lesson) => Lesson.fromJson(lesson))
  //           .toList();

  //   print(" --- lessons data: ${lessons.length}");
  //   return lessons;
  // }
}
