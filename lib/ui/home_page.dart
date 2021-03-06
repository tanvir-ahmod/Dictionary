import 'package:dictionary/bloc/dictionary/dictionary_bloc.dart';
import 'package:dictionary/bloc/dictionary/dictionary_event.dart';
import 'package:dictionary/bloc/dictionary/dictionary_state.dart';
import 'package:dictionary/bloc/history/history_bloc.dart';
import 'package:dictionary/bloc/history/history_event.dart';
import 'package:dictionary/bloc/history/history_state.dart';
import 'package:dictionary/model/history.dart';
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
    BlocProvider.of<HistoryBloc>(context).add(GetHistory());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          BlocBuilder<DictionaryBloc, DictionaryState>(
            builder: (context, state) {
              if (state is InitiatingDatabase) {
                return _onLoading();
              } else {
                return Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        _getCanvasWidget(),
                        _getMeaningWidget(),
                        _getHistoryWidget()
                      ],
                    ));
              }
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
      height: MediaQuery.of(context).size.height / 2.5,
    );
  }

  Widget _getMeaningWidget() {
    return BlocBuilder<DictionaryBloc, DictionaryState>(
        builder: (context, state) {
      if (state is MeaningDetectedState) {
        if (state.textMeaning == null || state.textMeaning.isEmpty)
          return Container();
        else {
          BlocProvider.of<HistoryBloc>(context).add(InsertHistory(
              History(textKey: state.textKey, textMeaning: state.textMeaning)));
          return Container(
            color: Hexcolor(Constants.MEANING_BACKGROUND_COLOR),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30, left: 24, right: 24),
            padding: EdgeInsets.all(20),
            child: Expanded(
              child: Text(
                '${state.textKey} : ${state.textMeaning}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        }
      }
      if (state is NoMeaningFoundState) {
        if (state.textKey == null || state.textKey.isEmpty) {
          return _notFoundWidget("Could not detect text!");
        } else
          return _notFoundWidget("No meaning found!");
      }
      return Container();
    });
  }

  Widget _onLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Initiating Database..."),
        ],
      ),
    );
  }

  Widget _getHistoryWidget() {
    return BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
      if (state is GetHistoryState) {
        final histories = state.historyList;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 24, right: 24),
            child: ListView.builder(
                itemCount: histories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        histories[index].textKey,
                        style: TextStyle(fontSize: 24),
                      ),
                      subtitle: Text(
                        histories[index].textMeaning,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }),
          ),
        );
      }
      return Container();
    });
  }

  Widget _notFoundWidget(String text) {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 30, left: 24, right: 24),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
