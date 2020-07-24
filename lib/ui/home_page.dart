import 'package:dictionary/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background.dart';
import 'canvas.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTimeLoad = prefs.getBool(Constants.FIRST_TIME_OPEN);
    return firstTimeLoad == null || !firstTimeLoad;
  }

  @override
  void initState()  {
    super.initState();

    isFirstTime().then((isFirstTime) {
      if (isFirstTime) _initializeDatabaseFistTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  _getCanvasWidget(),
                  _getMeaningWidget(),
                  _getHistoryWidget()
                ],
              )),
        ],
      ),
    );
  }

  Widget _getCanvasWidget() {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      margin: EdgeInsets.only(top: 150),
      child: CustomCanvas(),
      height: 400.0,
    );
  }

  Widget _getMeaningWidget() {
    return Container(
      color: Hexcolor('#5c6bc0'),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      padding: EdgeInsets.all(50),
      child: Row(
        children: <Widget>[
          Text(
            'পরীক্ষা\nপরীক্ষা',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _getHistoryWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 24, right: 24),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, count) {
              return Card(
                child: ListTile(
                  title: Text(
                    'test1',
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(
                    'পরীক্ষা',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _initializeDatabaseFistTime() async {
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var box = await Hive.openBox(Constants.DICTIONARY);
    String data = await loadAsset();
    var arr = data.split('|');
    for (var i = 0; i < arr.length;) {
      if (i + 1 < arr.length && i + 2 < arr.length) {
        box.put(arr[i + 1], arr[i + 2]);
      }
      i += 2;
    }
    var endTime = DateTime.now().millisecondsSinceEpoch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.FIRST_TIME_OPEN, false);

    print('required Time ${endTime - startTime} ms');
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/words.txt');
  }
}
