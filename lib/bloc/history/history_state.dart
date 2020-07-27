import 'package:dictionary/model/history.dart';

abstract class HistoryState {
  List<History> historyList;

  HistoryState({this.historyList});
}

class InitialingHistoryState extends HistoryState {}

class GetHistoryState extends HistoryState {
  GetHistoryState(List<History> historyList)
      : super(historyList: historyList);
}
