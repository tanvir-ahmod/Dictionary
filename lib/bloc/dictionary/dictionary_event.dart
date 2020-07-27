import 'dart:io';

abstract class DictionaryEvent {}

class InitiateDatabase extends DictionaryEvent {}

class GetMeaning extends DictionaryEvent {
  File imageFile;

  GetMeaning(this.imageFile) : assert(imageFile != null);
}

class ClearMeaning extends DictionaryEvent {}
