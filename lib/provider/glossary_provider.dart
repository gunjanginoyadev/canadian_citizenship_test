import 'package:canadian_citizenship/services/db_service.dart';

import '../libs.dart';

class GlossaryProvider extends ChangeNotifier {
  bool isDataLoaded = false;
  List<GlossaryModel> _originalData = [];
  List<GlossaryModel> data = [];

  Future<void> loadGlossaryData() async {
    isDataLoaded = false;
    notifyListeners();

    _originalData = await DBService().getAllGlossaryItems();
    data = List.from(_originalData);

    isDataLoaded = true;
    notifyListeners();
  }

  void searchGlossary(String query) {
    if (query.isEmpty) {
      data = List.from(_originalData);
    } else {
      data =
          _originalData
              .where((item) => item.word.toLowerCase().startsWith(query))
              .toList();
    }
    notifyListeners();
  }
}
