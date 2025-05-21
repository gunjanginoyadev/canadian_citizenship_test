import 'package:canadian_citizenship/services/pref_service.dart';
import 'package:flutter/material.dart';

class TestScoreHistoryProvider extends ChangeNotifier {
  List<int> scoreHistory = [];
  bool dataLoaded = false;

  void loadData() {
    dataLoaded = false;
    notifyListeners();

    List<int> scores = PrefService.getTestScoreHistory();
    scoreHistory = scores.reversed.toList();

    print(" --- scores: $scoreHistory");
    dataLoaded = true;
    notifyListeners();
  }

  Future<void> addScore(int score) async {
    print(" --- add score: $score");
    await PrefService.addTestHistoryScore(score);
    List<int> scores = PrefService.getTestScoreHistory();
    scoreHistory = scores.reversed.toList();
    print(" --- scores: $scoreHistory");
    notifyListeners();
  }
}
