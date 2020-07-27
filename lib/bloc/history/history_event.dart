import 'package:dictionary/model/history.dart';
import 'package:flutter/material.dart';

abstract class HistoryEvent {}

class InsertHistory extends HistoryEvent {
  History history;

  InsertHistory(this.history) : assert(history != null);
}

class GetHistory extends HistoryEvent {}
