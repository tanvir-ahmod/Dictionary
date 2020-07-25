import 'package:dictionary/dao/dictionary_dao.dart';

class DictionaryRepository {
  var dao = DictionaryDao();

  Future initializeDatabase() => dao.initializeDatabase();

  Future isFirstTime() => dao.isFirstTime();
}
