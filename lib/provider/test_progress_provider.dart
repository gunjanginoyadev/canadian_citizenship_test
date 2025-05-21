import 'package:canadian_citizenship/libs.dart';

class TestProgressProvider extends ChangeNotifier {
  int currentTestProgress = 0;
  // int totalProgress = 589;
  int totalProgress = 0;

  void increaseTestProgress(int index) {
    PrefService.increaseTestProgress(index.toString());
    currentTestProgress = PrefService.getTestProgress();
    notifyListeners();
  }

  void getTestProgress() {
    currentTestProgress = PrefService.getTestProgress();
    notifyListeners();
  }

  void init(context) {
    getTestProgress();
    Provider.of<MockTestProvider>(context, listen: false).mockTestData.length;
  }
}
