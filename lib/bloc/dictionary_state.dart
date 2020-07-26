abstract class DictionaryState {
  String textKey = "";
  String textMeaning = "";

  DictionaryState({this.textKey, this.textMeaning});
}

class InitialState extends DictionaryState {}

class InitiatedDatabaseState extends DictionaryState {}

class MeaningDetectedState extends DictionaryState {
  MeaningDetectedState({String textKey, String textMeaning})
      : super(textKey: textKey, textMeaning: textMeaning);
}

class NoMeaningFoundState extends DictionaryState {
  NoMeaningFoundState({String textKey, String textMeaning})
      : super(textKey: textKey, textMeaning: textMeaning);
}
