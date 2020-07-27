import 'package:dictionary/dao/history_dao.dart';
import 'package:dictionary/model/history.dart';

class HistoryRepository {
  final _historyDao = HistoryDao();

  Future insertHistory(History history) => _historyDao.insertHistory(history);

  Future getAllHistory() => _historyDao.getAllHistory();
}
