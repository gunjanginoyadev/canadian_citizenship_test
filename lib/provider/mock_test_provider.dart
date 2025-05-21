import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/services/db_service.dart';

class MockTestProvider extends ChangeNotifier {
  List<List<MockTestDbModel>> mockTestData = [];
  int currentProgress = 0;
  int totalQuestions = 0;
  bool isDataLoaded = false;

  Future<void> loadData() async {
    isDataLoaded = false;
    notifyListeners();
    List<String> categories = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
    ];

    for (String category in categories) {
      List<MockTestDbModel> data = await DBService()
          .getSpecificMockTestQuestions(category);
      mockTestData.add(data);
    }

    totalQuestions = mockTestData.fold(0, (sum, list) => sum + list.length);
    currentProgress = PrefService.getTestProgress();

    isDataLoaded = true;
    notifyListeners();

    print(" --- mock test data: ${totalQuestions}");
  }

  void updateTestProgress() {
    currentProgress = PrefService.getTestProgress();
    notifyListeners();
  }
}
