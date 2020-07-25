import 'dart:async';

import 'package:dictionary/bloc/dictionary_event.dart';
import 'package:dictionary/bloc/dictionary_state.dart';
import 'package:dictionary/repository/dictionary_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository repository;

  final _dictionaryController = StreamController<String>();

  DictionaryBloc({@required this.repository})
      : assert(repository != null),
        super(null);

  Stream<String> get result => _dictionaryController.stream;


  void dispose() {
    _dictionaryController.close();
  }

  @override
  Stream<DictionaryState> mapEventToState(DictionaryEvent event) async* {
    if (event is InitiateDatabase) {
      bool isFirstTime = await repository.isFirstTime();
      if (isFirstTime) {
        await repository.initializeDatabase();
        yield InitiatedDatabaseState();
      }
    }
  }
}
