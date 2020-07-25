import 'package:dictionary/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryDao {
  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTimeLoad = prefs.getBool(Constants.FIRST_TIME_OPEN);
    return firstTimeLoad == null || firstTimeLoad;
  }

  Future initializeDatabase() async {
    var dictionary = await Hive.openBox(Constants.DICTIONARY);
    String data = await _loadAsset();
    var arr = data.split('|');
    for (var i = 0; i < arr.length;) {
      if (i + 1 < arr.length && i + 2 < arr.length) {
        dictionary.put(arr[i + 1], arr[i + 2]);
      }
      i += 2;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.FIRST_TIME_OPEN, false);
    print('database initiated');
  }

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/words.txt');
  }

  Future<String> getMeaning(String key) async {
    var dictionary = await Hive.openBox(Constants.DICTIONARY);
    return dictionary.get(key);
  }
}
