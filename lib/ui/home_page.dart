import 'package:dictionary/bloc/dictionary_bloc.dart';
import 'package:dictionary/bloc/dictionary_event.dart';
import 'package:dictionary/bloc/dictionary_state.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'background.dart';
import 'canvas.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // initiate Database
    BlocProvider.of<DictionaryBloc>(context).add(InitiateDatabase());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          BlocBuilder<DictionaryBloc, DictionaryState>(
            builder: (context, state) {
              return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      _getCanvasWidget(),
                      _getMeaningWidget(),
                      _getHistoryWidget()
                    ],
                  ));
            },
          ),
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
    return BlocBuilder<DictionaryBloc, DictionaryState>(
        builder: (context, state) {
      if (state is MeaningDetectedState) {
        return state.textMeaning == null || state.textMeaning.isEmpty
            ? Container()
            : Container(
                color: Hexcolor(Constants.MEANING_BACKGROUND_COLOR),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20, left: 24, right: 24),
                padding: EdgeInsets.all(50),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${state.textKey}: ${state.textMeaning}',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              );
      }
      if (state is NoMeaningFoundState) {
        if (state.textKey == null || state.textKey.isEmpty) {
          return _notFoundWidget("Could not detect text");
        }
        else
          return _notFoundWidget("No meaning found");
      }
      return Container();
    });
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

  Widget _notFoundWidget(String text) {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      padding: EdgeInsets.all(50),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
