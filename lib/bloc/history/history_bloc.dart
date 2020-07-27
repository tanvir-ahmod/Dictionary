import 'package:dictionary/bloc/history/history_event.dart';
import 'package:dictionary/bloc/history/history_state.dart';
import 'package:dictionary/model/history.dart';
import 'package:dictionary/repository/history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final _repository = HistoryRepository();

  HistoryBloc(HistoryState initialState) : super(initialState);

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    if (event is InsertHistory) {
      print('at insert history bloc ${event.history.textKey}');
      await _repository.insertHistory(event.history);
      yield* _mapGetHistoryState();
    } else if (event is GetHistory) {
      yield* _mapGetHistoryState();
    }
  }

  Stream<HistoryState> _mapGetHistoryState() async* {
    List<History> histories = await _repository.getAllHistory();
    yield GetHistoryState(histories);
  }
}
