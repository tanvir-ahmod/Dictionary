import 'package:dictionary/model/history.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:hive/hive.dart';

class HistoryDao {
  Future<List<History>> getAllHistory() async {
    final histories = Hive.box<History>(Constants.HISTORY);
    List<History> result = [];
    for (var i = 0; i < histories.length; i++) {
      result.add(histories.getAt(i));
    }
    return result;
  }

  Future insertHistory(History history) async {
    Box<History> histories = Hive.box<History>(Constants.HISTORY);
    histories.add(history);
  }
}
