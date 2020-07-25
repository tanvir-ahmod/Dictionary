import 'dart:io';

import 'package:dictionary/dao/dictionary_dao.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class DictionaryRepository {
  var dao = DictionaryDao();

  Future initializeDatabase() => dao.initializeDatabase();

  Future isFirstTime() => dao.isFirstTime();

  Future<Map<String, String>> getMeaning(File imageFile) async {
    String textFromImage = await _detectText(imageFile);
    String meaning = await dao.getMeaning(textFromImage.toLowerCase());
    return {Constants.TEXT_KEY: textFromImage, Constants.TEXT_MEANING: meaning};
  }

  Future<String> _detectText(File imageFile) async {
    FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(imageFile);

    TextRecognizer textRecogniser = FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecogniser.processImage(firebaseVisionImage);
    print('${visionText.blocks}');
    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine line in textBlock.lines) {
        for (TextElement word in line.elements) {
          return word.text;
        }
      }
    }
    return "";
  }
}
