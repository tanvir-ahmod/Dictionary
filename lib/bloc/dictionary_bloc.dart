import 'dart:async';

import 'package:dictionary/bloc/dictionary_event.dart';
import 'package:dictionary/bloc/dictionary_state.dart';
import 'package:dictionary/repository/dictionary_repository.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository repository;

  final _dictionaryController = StreamController<String>();

  DictionaryBloc({@required this.repository})
      : assert(repository != null),
        super(InitialState());

  Stream<String> get result => _dictionaryController.stream;

  void dispose() {
    _dictionaryController.close();
  }

  @override
  Stream<DictionaryState> mapEventToState(DictionaryEvent event) async* {
    if (event is InitiateDatabase) {
      bool isFirstTime = await repository.isFirstTime();
      if (isFirstTime) {
        yield InitiatingDatabase();
        await repository.initializeDatabase();
        yield InitiatedDatabaseState();
      }
    } else if (event is GetMeaning) {
      yield* _getMeaningToState(event);
    } else if (event is ClearMeaning) {
      yield MeaningDetectedState(textKey: "", textMeaning: "");
    }
  }

  Stream<DictionaryState> _getMeaningToState(
      GetMeaning getMeaningEvent) async* {
    Map<String, String> textMeaning =
        await repository.getMeaning(getMeaningEvent.imageFile);

    if (textMeaning[Constants.TEXT_MEANING] == null ||
        textMeaning[Constants.TEXT_MEANING] == null) {
      yield NoMeaningFoundState(
          textKey: textMeaning[Constants.TEXT_KEY],
          textMeaning: textMeaning[Constants.TEXT_MEANING]);
    } else {
      yield MeaningDetectedState(
          textKey: textMeaning[Constants.TEXT_KEY],
          textMeaning: textMeaning[Constants.TEXT_MEANING]);
    }
  }
}
