abstract class DictionaryState {
  String meaning = "";

  DictionaryState({this.meaning});
}

class InitialState extends DictionaryState {}
class InitiatedDatabaseState extends DictionaryState {}

class MeaningDetectedState extends DictionaryState {
  MeaningDetectedState(String meaning) : super(meaning: meaning);
}
